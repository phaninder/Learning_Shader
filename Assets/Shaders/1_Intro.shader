// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/1_Intro"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
	}
		SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			half4 _Color;
			
			struct VertexInput
			{
				float4 vertex :POSITION;
			};

			struct VertexOutput
			{
				float4 pos:SV_POSITION;
			};

			VertexOutput vert(VertexInput vIn)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(vIn.vertex);
				return o;
			}

			float4 frag(VertexOutput fIn) :COLOR
			{
				return _Color;
			}
			ENDCG
		}
	}
}
