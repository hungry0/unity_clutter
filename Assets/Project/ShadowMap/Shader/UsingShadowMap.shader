Shader "Unlit/UsingShadowMap"
{
	Properties
	{
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct v2f {
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float4 proj : TEXCOORD3;
				float2 depth : TEXCOORD4;
			};

			float4x4 lightProjectionMatrix;
			sampler2D depthTexture;

			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.depth = o.pos.zw;
				lightProjectionMatrix = mul(lightProjectionMatrix, unity_ObjectToWorld);
				o.proj = mul(lightProjectionMatrix, v.vertex);

				return o;
			}

			fixed4 frag(v2f v) : COLOR
			{
				fixed4 col = fixed4(1.0,1.0,1.0,1.0);

				float depth = v.depth.x / v.depth.y;
				fixed4 dcol = tex2Dproj(depthTexture, v.proj);
				float d = DecodeFloatRGBA(dcol);
				float shadowScale = 1;
				if (depth > d)
				{
					shadowScale = 0.55;
				}

				return fixed4(1.0, 1.0, 1.0, 1.0) * shadowScale;

			}
			ENDCG
		}
	}
}
