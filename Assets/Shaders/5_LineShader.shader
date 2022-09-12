// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/5_LineShader"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
        _MainTex("Texture",2D) = "white"{}
        _LineStart("LineStart",float) = 0.1
        _LineEnd("LineEnd",float) = 0.5
        _ShowInX ("Show X", int) = 1
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

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _LineStart;
            float _LineEnd;
            int _ShowInX;

            struct VertexInput
            {
                float4 pos:POSITION;
                float4 texCoord:TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 texCoord : TEXCOORD0;
            };

            VertexOutput vert(VertexInput vIn)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(vIn.pos);
                o.texCoord.xy = vIn.texCoord * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texCoord.zw = 0;
                return o;
            }

            float DrawLine(float2 uv, float start, float end)
            {
                if (_ShowInX == 1)
                {
                    if (uv.x > start && uv.x < end)
                    {
                        return 1;
                    }
                }
                else
                {
                    if (uv.y > start && uv.y < end)
                    {
                        return 1;
                    }
                }
                return 0;
            }

            float4 frag(VertexOutput o) :COLOR
            {
                float4 col = tex2D(_MainTex,o.texCoord) *_Color;
                col.a = DrawLine(o.texCoord.xy, _LineStart, _LineEnd);
                return col;
            }
            ENDCG
        }
    }
}
