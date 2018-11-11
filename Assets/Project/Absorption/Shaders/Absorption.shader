Shader "Unlit/Absorption"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Intensity("Intensity", Range(0,1)) = 0.0
		_Diffuse("Diffuse", Color) = (0.0,0.0,0.0,1.0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 proj : TEXCOORD1;
				float rdepth : TEXCOORD2;
			};

			sampler2D depthTexture;
			matrix lightMatrix;
			matrix cameraMatrix;

			float _Intensity;
			float4 _Diffuse;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				lightMatrix = mul(lightMatrix, unity_ObjectToWorld);

				o.rdepth = length(mul(cameraMatrix, mul(unity_ObjectToWorld, v.vertex)));

				o.proj = mul(lightMatrix, v.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 depth = tex2Dproj(depthTexture, i.proj);
				float depthInCamera = DecodeFloatRGBA(depth);

				float s = i.rdepth - depthInCamera;

				return exp(-s * _Intensity) * _Diffuse;
			}
			ENDCG
		}
	}
}
