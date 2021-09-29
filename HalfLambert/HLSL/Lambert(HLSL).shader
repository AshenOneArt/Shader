

Shader "Unity Shaders Book/Chapter 5/Lambert Shader"
{
	Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
	}
	SubShader {
				HLSLINCLUDE

				half4 _Diffuse;

				ENDHLSL


		Pass { 
			Tags { "LightMode"="UniversalForward" }
		
			HLSLPROGRAM
			
			#pragma vertex vert
			
			#pragma fragment frag
			
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			
			
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
				
	
				VertexNormalInputs normalInputs = GetVertexNormalInputs(v.normal.xyz);
				o.worldNormal = normalInputs.normalWS;
				
				return o;
			}
			
			float4 frag(v2f i) : SV_Target {
			
				float3 ambient = half3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
				
				float3 worldNormal = normalize(i.worldNormal);

				Light light = GetMainLight();
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