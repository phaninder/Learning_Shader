// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/2_TextureMapping"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("Texture",2D) = "white"{}
	}
	SubShader
	{
		Tags
		{
		"Queue" = "Transparent" 
		"IgnoreProjector" = "True"
		"RenderType" = "Opaque"
		}
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert;
			#pragma fragment frag;

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half4 _Color;

			struct VertexInput
			{
				float4 pos:POSITION;
				float4 uv:TEXCOORD0;
			};

			struct VertexOutput
			{
				float4 pos:SV_POSITION;
				float4 uv:TEXCOORD0;
			};

			VertexOutput vert(VertexInput vIn)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(vIn.pos);
				o.uv.xy = (vIn.uv * _MainTex_ST.xy + _MainTex_ST.zw);
				o.uv.zw = 0;
				return o;
			}

			float4 frag(VertexOutput o):COLOR
			{
				return tex2D(_MainTex,o.uv) * _Color;
			}

			ENDCG
		}
	}
}
