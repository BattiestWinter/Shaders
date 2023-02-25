Shader "MyShader/HologramShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Hologram("Hologram", 2D) = "white" {}
        _Frequency("Frequency", Range(1,30)) = 1
        _Speed("Speed", Range(0,5)) = 1
    }

    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
            "Queue" = "Transparent" 
        }

        //Efecto de Translucidez
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 huv : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            //Ligar propiedades con variables
            sampler2D _MainTex;
            sampler2D _Hologram;
            //Maneja la repetición
            float4 _MainTex_ST;
            float4 _Color;
            float _Frequency;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.huv = v.uv;
                o.huv.y += _Time*_Speed;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv)*_Color;
                fixed4 holo = tex2D(_Hologram, i.uv);
                //Senoidal parte positiva
                col.a = abs(sin(i.huv.y * _Frequency));

                return col;
            }

            ENDCG
        }     
    }
    FallBack "Diffuse"
}
