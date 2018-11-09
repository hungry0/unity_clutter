Shader "Unlit/LightSpaceDistance"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D lightDepthTex;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float dist : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float trace(float3 P, float4x4 lightTexMatrix, float4x4 lightMatrix, sampler2D lightDepthTex)
			{
				float4 texCoord = mul(lightTexMatrix, float4(P, 1.0));

				float d_i = tex2Dproj(lightDepthTex, texCoord);

				float4 Plight = mul(lightMatrix, float4(P, 1.0));

				float4 d_o = length(Plight);

				float s = d_o - d_i;

				return s;
			}
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.dist = length(mul(unity_ObjectToWorld, v.vertex));

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//return (i.dist,0,0,1);
				return EncodeFloatRGBA(i.dist);
			}
			ENDCG
		}
	}
}