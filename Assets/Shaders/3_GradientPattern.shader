// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/3_GradientPattern"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("Main Tex",2D) = "White"{}
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

			#pragma vertex vert
			#pragma fragment frag

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;

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

			VertexOutput vert(VertexInput vIn)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(vIn.vertex);
				o.texCoord.xy = vIn.texCoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.texCoord.zw = 0;
				return o;
			}

			float4 frag(VertexOutput o) :COLOR
			{
				float4 color = tex2D(_MainTex,o.texCoord) * _Color;
				color.a = o.texCoord.x;
				return color;
			}
			ENDCG
		}
	}
}
