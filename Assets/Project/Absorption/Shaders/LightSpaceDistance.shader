﻿Shader "Unlit/LightSpaceDistance"
{
	Properties
	{
		_Scale("Scale", Range(0,2)) = 1.5
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Cull Off

		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			matrix cameraMatrix;
			float _Scale;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float dist : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float4 worldPos = mul(unity_ObjectToWorld, v.vertex + v.normal * _Scale);

				o.dist = length(mul(cameraMatrix, worldPos));

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return EncodeFloatRGBA(i.dist);
			}
			ENDCG
		}
	}
}