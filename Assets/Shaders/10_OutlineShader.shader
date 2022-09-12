Shader "Custom/10_OutlineShader"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor("Outline Color",Color) = (0,0,0,1)
        _OutlineWidth("Outline width",Float) = 0.1
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

            Pass
            {
            
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Back
            Zwrite off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float4 _OutlineColor;
            float _OutlineWidth;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float4 ScaleUp(float4 pos,float width)
            {
                float4x4 scaleMat;
                UNITY_INITIALIZE_OUTPUT(float4x4, scaleMat);
                scaleMat[0][0] = 1.0 + width;
                scaleMat[1][1] = 1.0 + width;
                scaleMat[2][2] = 1.0 + width;
                scaleMat[3][3] = 1.0 + width;

                return mul(scaleMat, pos);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(ScaleUp(v.vertex,_OutlineWidth));                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _OutlineColor;
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            float4 _Color;
            float4 _MainTex_ST;

            struct VertexInput
            {
                float4 pos:POSITION;
                float4 uv :TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos:SV_POSITION;
                float4 uv:TEXCOORD0;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv.xy = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.zw = 0;
                return o;
            }

            float4 frag(VertexOutput o) :COLOR
            {
                return tex2D(_MainTex,o.uv) * _Color;
            }
            ENDCG
        }
    }
}
