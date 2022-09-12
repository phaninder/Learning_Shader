Shader "Custom/6_CircleShader"
{
   Properties
   {
	   _Color("Color",Color) = (1,1,1,1)
	   _MainTex("Texture",2D) = "white"{}
	   _Center("Center",float) = 1
		_Radius("Radius",float) = 0.5
	   _Feather("Feather",Range(0.01,0.1)) = 0.02
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
			#pragma vertex Vert
			#pragma fragment Frag

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Center;
			float _Radius;
			float _Feather;

			struct VertexInput
			{
				float4 vertex:POSITION;
				float4 texCoord:TEXCOORD0;
			};

			struct VertexOutput
			{
				float4 pos:SV_POSITION;
				float4 texCoord:TEXCOORD0;
			};

			float DrawCircle(float2 uv, float2 center, float radius)
			{
				float circle = pow((uv.x - center.x), 2) + pow((uv.y - center.y), 2);
				float radiusSq = pow(radius, 2);

				if (circle < radiusSq)
				{
					return smoothstep(radiusSq, radiusSq - _Feather, circle);
				}

				return 0;
			}

			VertexOutput Vert(VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texCoord.xy = v.texCoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.texCoord.zw = 0;
				return o;
			}

			float4 Frag(VertexOutput v) :COLOR
			{
				float4 col = tex2D(_MainTex,v.texCoord) * _Color;
				col.a = DrawCircle(v.texCoord.xy, _Center, _Radius);
				return col;
			}

			ENDCG
		}
   }
}
