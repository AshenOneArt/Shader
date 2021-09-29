
Shader "Unity Shaders Book/Chapter 5/Lambert_Vert"
{
	Properties
	{
		_Diffuse("Color",color) = (1,1,1,1)
	}
	
	SubShader
	{

		HLSLINCLUDE
		float4 _Diffuse;
		ENDHLSL
		
		
		Pass
		{
			Tags{"LightMode" = "UniversalForward"}
			
			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			struct Attributes
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct Varyings
			{
				half4 pos : SV_POSITION;
				half3 color : COLOR;
			};

			Varyings vert(Attributes i)
			{
				Varyings o;
				VertexPositionInputs PositionInputs = GetVertexPositionInputs(i.vertex.xyz);
				o.pos = PositionInputs.positionCS;
				
				VertexNormalInputs NormalInputs = GetVertexNormalInputs(i.normal.xyz);
				half3 normalWS = NormalInputs.normalWS;

				Light light = GetMainLight();
				half3 lightDirection = normalize(light.direction);
				half3 lightColor = light.color;

				half3 ambient = half3(unity_SHAr. w,unity_SHAg.w, unity_SHAb.w);

				o.color = _Diffuse.rgb * lightColor * dot(lightDirection, normalWS);
				o.color += ambient;

				return o;
			}

			half4 frag(Varyings i) : SV_Target
			{
				half3 color = i.color;
				return half4(color,1.0);
			}
			ENDHLSL
		}
	}
	FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
