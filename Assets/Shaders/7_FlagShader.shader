Shader "Custom/7_FlagShader"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("Main Texture",2D) = "White"{}
		_Frequency("Frequency",float) = 1
		_Amplitude("Amplitude",float) = 1
		_Speed("Speed",float) = 1
		_UseCos("UseCos",int) = 1
	}

	SubShader
	{
		Tags
		{
			"Queue"="Transparent"
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
			float _Frequency;
			float _Amplitude;
			float _Speed;
			int _UseCos;

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

			float4 FlagAnimation(float4 pos, float2 uv)
			{
				pos.z = pos.z + sin((uv.x + _Time.y * _Speed) * _Frequency) * (_Amplitude * uv.x);
				return pos;
			}

			float4 NewFlagAnim(float4 pos, float2 uv)
			{
				pos.z += cos((uv.x + _Time.y * _Speed) * _Frequency) * (_Amplitude * uv.x );
				return pos;
			}

			VertexOutput Vert(VertexInput v)
			{
				VertexOutput o;
				if (_UseCos == 1)
				{
					v.vertex = NewFlagAnim(v.vertex, v.texCoord);
				}
				else
				{
					v.vertex = FlagAnimation(v.vertex, v.texCoord);
				}

				o.pos = UnityObjectToClipPos(v.vertex);
				o.texCoord.xy = v.texCoord * _MainTex_ST.xy + _MainTex_ST.zw;
				o.texCoord.zw = 0;
				return o;
			}

			float4 Frag(VertexOutput o) :COLOR
			{
				float4 col = tex2D(_MainTex,o.texCoord) * _Color;
				return col;
			}

			ENDCG
		}
	}
}
