
//简单Lambert光照模型实现 ： https://zhuanlan.zhihu.com/p/336670858
Shader "Unity Shaders Book/Chapter 5/Lambert Shader"
{
	Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
	}
	SubShader {
				
				HLSLINCLUDE

				half4 _Diffuse;	// HLSL引入变量时，需要HLSLINCLUDE与ENDHLSL包含，此阶段在Subshader之后，Pass之前，与SG不同的是，SG引入变量是在Pass之后。

				ENDHLSL


		Pass { 
			Tags { "LightMode"="UniversalForward" } //SG Tag : "LightMode" = "ForwardBase"
		
			HLSLPROGRAM
			
			#pragma vertex vert
			
			#pragma fragment frag
			
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl" //SG ：#include "Lighting.cginc"
			
			
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
			};
			
			v2f vert(a2v v) {
				v2f o;

				VertexPositionInputs positionInputs = GetVertexPositionInputs(v.vertex.xyz);
				o.pos = positionInputs.positionCS;
				
				//SG : o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
	
				VertexNormalInputs normalInputs = GetVertexNormalInputs(v.normal.xyz);
				o.worldNormal = normalInputs.normalWS;
				
				//SG : o.worldNormal = mul(v.normal, (float3x3)_World2Object);
				
				return o;
			}
			
			float4 frag(v2f i) : SV_Target {
			
				float3 ambient = half3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w); 
				//Unity Shader内置着色器Ambient：球谐光照  详见：https://blog.csdn.net/wodownload2/article/details/104208469
				//CG : UNITY_LIGHTMODEL_AMBIENT.xyz;
				float3 worldNormal = normalize(i.worldNormal);

				Light light = GetMainLight();//#include "Lighting.hlsl"
				half3 worldLightDir = light.direction;
				

				half halfLambert = dot(worldNormal, worldLightDir) * 0.5 + 0.5;
				half3 diffuse = light.color * _Diffuse.rgb * halfLambert;
				
				half3 color = ambient * 1.0 + diffuse;
				
				return half4(color, 1.0);
			}
			
			ENDHLSL
		}
	} 
	FallBack "Hidden/Universal Render Pipeline/FallbackError" 
}
