Shader "Unlit/Absorption"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Intensity("Intensity", Range(0,1)) = 0.0
		_Diffuse("Diffuse", Color) = (0.0,0.0,0.0,1.0)
		_Scale("Scale", Range(-0.02,0.02)) = 0.01
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		//Cull Off
		Blend SrcAlpha OneMinusSrcAlpha

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
				float normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 proj : TEXCOORD1;
				float rdepth : TEXCOORD2;
			};

			sampler2D global_depthTexture;
			matrix global_lightMatrix;
			matrix global_cameraMatrix;

			float _Intensity;
			float4 _Diffuse;
			float _Scale;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _Scale);

				global_lightMatrix = mul(global_lightMatrix, unity_ObjectToWorld);

				o.rdepth = length(mul(global_cameraMatrix, mul(unity_ObjectToWorld, v.vertex)));

				o.proj = mul(global_lightMatrix, v.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 depth = tex2Dproj(global_depthTexture, i.proj);
				float depthInCamera = DecodeFloatRGBA(depth);

				float s = i.rdepth - depthInCamera;

				return _Diffuse * exp(-s * _Intensity);
			}
			ENDCG
		}
	}
}
