// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/9_NormalMap"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("Texture",2D) = "white"{}
		_NormalMap("Normal map",2D) = "white"{}
		_MinLight("Min Light",Float) = 0.1
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Opaque"
		}

		pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;
			 
			uniform float _MinLight;

			struct VertexInput
			{
				float4 pos:POSITION;
				float4 uv:TEXCOORD0;
				float4 normal:NORMAL;
				float4 tangent:TANGENT;
			};

			struct VertexOutput
			{
				float4 pos:POSITION;
				float4 uv:TEXCOORD0;
				float3 normalWorld :TEXCOORD1;
				float3 tangentWorld :TEXCOORD2;
				float3 binormalWorld :TEXCOORD3;
				float4 normalUV:TEXCOORD4;
			};

			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.uv.xy = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = 0;

				o.normalUV.xy = v.uv * _NormalMap_ST.xy + _NormalMap_ST.zw;
				o.normalUV.zw = 0;

				o.normalWorld = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
				o.tangentWorld = normalize(mul((float3x3)unity_ObjectToWorld, v.tangent));
				//float3 binormal = cross(v.normal, o.tangent);
				o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld) * v.tangent.w);

				return o;
			}

			float4 NormalFromColor(float4 color)
			{
				#if defined (UNITY_NO_DXT5nm)
					return color.xyz * 2 - 1;
				#else
					float4 normalVal;
					normalVal = float4(color.a * 2.0 - 1.0,
						color.g * 2.0 - 1.0, 0.0,1.0);
					normalVal.z = sqrt(1.0 - dot(normalVal, normalVal));
					return normalVal;
				#endif
			}

			float4 frag(VertexOutput o) :COLOR
			{
				float4 color = tex2D(_NormalMap,o.normalUV);
				float4 normalAtPixel = NormalFromColor(color);
				
				float3x3 tbn = float3x3(o.tangentWorld, o.binormalWorld, o.normalWorld);
				tbn = transpose(tbn);

				float4 worldNormalAtPixel = float4(normalize(mul(normalAtPixel.xyz, tbn)),1.0);

				float lightIntensity = max(_MinLight, dot(worldNormalAtPixel, _WorldSpaceLightPos0));
				fixed4 col = lightIntensity * tex2D(_MainTex, o.uv) *_Color;
				col.w = 1;
				return col;
			}
			ENDCG
		}
	}
}
