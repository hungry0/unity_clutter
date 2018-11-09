Shader "Unlit/SphereShader"
{
	Properties
	{
		_LightPos("Light Pos", Vector) = (.34, .85, .92, 1)
		diffuseColor("Diffuse Color", Color) = (1,1,1,1)
		specularColor("Specular Color", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 N : TEXCOORD1;
				float3 H : TEXCOORD2;
			};

			float4 _LightPos;
			float4 diffuseColor;
			float4 specularColor;

			sampler2D _MainTex;
			float4  _MainTex_ST;

			float4 GenerateSkinLUT(float2 P) // P.x = dot(N, L), P.y = dot(N, H) H = halfVector
			{
				float wrap = 0.2;
				float scatterWidth = 0.3;
				float4 scatterColor = float4(0.15, 0.0, 0.0, 1.0);
				float shininess = 40.0;

				float NdotL = P.x * 2 - 1;  // remap from [0, 1] to [-1, 1]


				float NdotH = P.y * 2 - 1;

				float NdotL_wrap = (NdotL + wrap) / (1 + wrap); // wrap lighting

				float diffuse = max(NdotL_wrap, 0.0);

				// add color tint at transition from light to dark

				float scatter = smoothstep(0.0, scatterWidth, NdotL_wrap) *
					smoothstep(scatterWidth * 2.0, scatterWidth,
						NdotL_wrap);

				float specular = pow(NdotH, shininess);
				if (NdotL_wrap <= 0) specular = 0;
				float4 C;
				C.rgb = diffuse + scatter * scatterColor;
				C.a = specular;
				return C;
			}

			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				o.N = UnityObjectToWorldNormal(v.normal);

				float3 worldPos = UnityObjectToWorldDir(v.vertex);
				float3 posToLight = _WorldSpaceLightPos0.xyz - worldPos;
				float3 posToCamera = _WorldSpaceCameraPos - worldPos;

				o.H = normalize(normalize(posToLight) + normalize(posToCamera));

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 P;
				P.x = dot(i.N, _WorldSpaceLightPos0.xyz);
				P.y = dot(i.N, i.H);

				P = P * 0.5 + 0.5;

				float4 light = GenerateSkinLUT(P);

				//return light;
				
				return fixed4(diffuseColor.rgb * light.rgb + specularColor.rgb * light.rgb, 1.0);
			}

			ENDCG
		}
	}
}
