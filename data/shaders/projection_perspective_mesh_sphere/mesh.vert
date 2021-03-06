#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable
#define PI 3.14159265
layout(location = 0) in vec3 inPos;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inUV;
layout(location = 3) in vec3 inColor;

layout(binding = 0) uniform UBO {
  mat4 projection;
  mat4 model;
  vec4 lightPos;
  vec3 sphereCenter;
  float shepreRadius;
}
ubo;

layout(location = 0) out vec3 outNormal;
layout(location = 1) out vec3 outColor;
layout(location = 2) out vec2 outUV;
layout(location = 3) out vec3 outViewVec;
layout(location = 4) out vec3 outLightVec;

out gl_PerVertex {
  vec4 gl_Position;
};

vec2 genUVForSphere() {
  vec3 d = normalize(ubo.sphereCenter - inPos);
  float u = 0.5 + atan(d.z, d.x) / (2 * PI);
  float v = 0.5 - asin(d.y) / PI;
  return vec2(u, v);
}

void main() {
  outNormal = inNormal;
  outColor = inColor;
  outUV = genUVForSphere();  // inUV;
  gl_Position = ubo.projection * ubo.model * vec4(inPos.xyz, 1.0);

  vec4 pos = ubo.model * vec4(inPos, 1.0);
  outNormal = mat3(ubo.model) * inNormal;
  vec3 lPos = mat3(ubo.model) * ubo.lightPos.xyz;
  outLightVec = lPos - pos.xyz;
  outViewVec = -pos.xyz;
}