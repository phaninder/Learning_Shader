// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/4_UsefulFunctions"
{
	Properties
	{
		_Offset("Offset",Float) = 0.2
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("Texture",2D) = "white"{}
		_TmValue("Time",float) = 0
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
			float _Offset;
			float _TmValue;

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
			
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texCoord.xy = v.texCoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.texCoord.zw = 0;
				return o;
			}

			float4 frag(VertexOutput o) :COLOR
			{
				float4 col = tex2D(_MainTex,o.texCoord) * _Color;
				_TmValue = cos(_Time.z * _Offset);//sin(_Time.x * _Offset);
				col.a = _TmValue;  //sqrt(o.texCoord.x);
				return col;
			}
			ENDCG
		}
	}
}
