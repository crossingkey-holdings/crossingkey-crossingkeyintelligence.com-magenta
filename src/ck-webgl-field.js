const VERTEX = `
  attribute vec2 position;
  void main() { gl_Position = vec4(position, 0.0, 1.0); }
`

const FRAGMENT = `
  precision highp float;
  uniform vec2 u_resolution;
  uniform vec2 u_pointer;
  uniform float u_time;

  float line(float value, float width) { return 1.0 - smoothstep(0.0, width, abs(value)); }
  float hash(vec2 p) { return fract(sin(dot(p, vec2(41.13, 289.71))) * 45758.5453); }

  void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    vec2 p = uv - 0.5;
    p.x *= u_resolution.x / u_resolution.y;
    vec2 pointer = u_pointer - 0.5;
    pointer.x *= u_resolution.x / u_resolution.y;

    float lane = 0.0;
    for (int i = 0; i < 7; i++) {
      float offset = float(i) * 0.055;
      float corner = max(abs(p.x + 0.24), abs(p.y - 0.03));
      lane += line(corner - (0.15 + offset), 0.0022 + float(i) * 0.00038) * (0.85 - float(i) * 0.08);
    }

    vec2 grid = fract((p + vec2(0.5)) * 18.0) - 0.5;
    float traces = (line(grid.x, 0.008) + line(grid.y, 0.008)) * 0.055;
    float nodes = 0.0;
    vec2 cell = floor((p + vec2(0.5)) * 10.0);
    vec2 local = fract((p + vec2(0.5)) * 10.0) - 0.5;
    float active = step(0.79, hash(cell));
    nodes = active * (1.0 - smoothstep(0.008, 0.026, length(local))) * 0.92;

    float sweep = sin((p.x + p.y) * 8.0 - u_time * 0.62) * 0.5 + 0.5;
    float flow = lane * (0.34 + sweep * 0.66);
    float proximity = 1.0 - smoothstep(0.0, 0.44, length(p - pointer));
    float glow = lane * 0.45 + nodes * 1.2 + proximity * 0.16;

    vec3 ink = vec3(0.007, 0.0, 0.012);
    vec3 magenta = vec3(0.98, 0.05, 0.48);
    vec3 hot = vec3(1.0, 0.28, 0.70);
    vec3 color = ink;
    color += magenta * (traces + flow * 0.52 + nodes * 0.52);
    color += hot * glow * glow * 0.28;
    color += magenta * proximity * 0.06;
    float vignette = smoothstep(1.18, 0.18, length(p));
    color *= 0.58 + vignette * 0.42;
    gl_FragColor = vec4(color, 1.0);
  }
`

function compile(gl, type, source) {
  const shader = gl.createShader(type)
  gl.shaderSource(shader, source)
  gl.compileShader(shader)
  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) throw new Error(gl.getShaderInfoLog(shader) || 'Shader compile failed')
  return shader
}

export function initCKWebGLField() {
  if (window.matchMedia?.('(prefers-reduced-motion: reduce)').matches) return false
  if (document.querySelector('#ck-webgl-field')) return true
  const canvas = document.createElement('canvas')
  canvas.id = 'ck-webgl-field'
  canvas.className = 'ck-webgl-field'
  canvas.setAttribute('aria-hidden', 'true')
  const gl = canvas.getContext('webgl', { alpha: false, antialias: false, powerPreference: 'low-power' })
  if (!gl) return false

  try {
    const program = gl.createProgram()
    gl.attachShader(program, compile(gl, gl.VERTEX_SHADER, VERTEX))
    gl.attachShader(program, compile(gl, gl.FRAGMENT_SHADER, FRAGMENT))
    gl.linkProgram(program)
    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) throw new Error(gl.getProgramInfoLog(program) || 'Program link failed')

    const buffer = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer)
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 3, -1, -1, 3]), gl.STATIC_DRAW)
    const position = gl.getAttribLocation(program, 'position')
    const resolution = gl.getUniformLocation(program, 'u_resolution')
    const pointer = gl.getUniformLocation(program, 'u_pointer')
    const time = gl.getUniformLocation(program, 'u_time')
    const state = { x: 0.68, y: 0.28, active: true }

    function resize() {
      const dpr = Math.min(window.devicePixelRatio || 1, 1.5)
      canvas.width = Math.floor(window.innerWidth * dpr)
      canvas.height = Math.floor(window.innerHeight * dpr)
      canvas.style.width = `${window.innerWidth}px`
      canvas.style.height = `${window.innerHeight}px`
      gl.viewport(0, 0, canvas.width, canvas.height)
    }

    document.body.prepend(canvas)
    resize()
    window.addEventListener('resize', resize, { passive: true })
    window.addEventListener('pointermove', (event) => {
      state.x = event.clientX / window.innerWidth
      state.y = 1 - (event.clientY / window.innerHeight)
    }, { passive: true })

    gl.useProgram(program)
    gl.enableVertexAttribArray(position)
    gl.vertexAttribPointer(position, 2, gl.FLOAT, false, 0, 0)
    const render = (now) => {
      if (document.hidden) return requestAnimationFrame(render)
      gl.uniform2f(resolution, canvas.width, canvas.height)
      gl.uniform2f(pointer, state.x, state.y)
      gl.uniform1f(time, now / 1000)
      gl.drawArrays(gl.TRIANGLES, 0, 3)
      requestAnimationFrame(render)
    }
    requestAnimationFrame(render)
    document.documentElement.dataset.ckRenderer = 'webgl'
    return true
  } catch (error) {
    canvas.remove()
    return false
  }
}
