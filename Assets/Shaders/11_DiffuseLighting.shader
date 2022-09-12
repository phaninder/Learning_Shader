Shader "Custom/11_DiffuseLighting"
{
	Properties
	{
		_MainTex("Texture",2D) = "white"{}
		_Color ("Color",Color) = (1.0,1.0,1.0,1.0)
	}

	SubShader
	{
		Tags
		{
			"LightMode" = "ForwardBase"
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Opaque"
		}

		pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			uniform sampler2D _MainTex;
			uniform float4 _Color;
			uniform float4 _MainTex_ST;
			//uniform float4 _WorldSpaceLightPos0;
			uniform float4 _LightColor0;

			struct vertexInput
			{
				float4 pos:POSITION;
				float4 uv:TEXCOORD0;
				float4 normal:NORMAL;
			};

			struct vertexOutput
			{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float3 worldNormal :TEXCOORD1;
				float4 worldVertPos :TEXCOORD2;
			};

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldVertPos = mul(unity_ObjectToWorld, v.pos);
				return o;
			}

			float4 frag(vertexOutput o) : COLOR
			{
				fixed4 lightDir = normalize(_WorldSpaceLightPos0);
				fixed intensity = max(0, dot(o.worldNormal, lightDir)) + 0.15;
				fixed4 col = intensity * tex2D(_MainTex, o.uv)  * _LightColor0;
				col.w = 1;
				return col;
			}

			ENDCG
		}
	}
}
