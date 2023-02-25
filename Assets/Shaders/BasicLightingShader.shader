Shader "MyShader/BasicLightingSahder"
{
    Properties
    {
        _EmissiveColor ("Color emisivo", COLOR) = (1,1,1,1)
        _AmbientColor ("Color ambiental", COLOR) = (1,1,1,1)
        _MySliderValue ("Valor Slider", Range(0,10)) = 2.5
        _RampTex("Textura rampa", 2D) = "white" {}
    }

    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
        }

        CGPROGRAM
        #pragma surface surf BasicDiffuse

        float4 _EmissiveColor;
        float4 _AmbientColor;
        float _MySliderValue;
        sampler2D _RampTex;

        struct Input
        {
            float2 uv_MainTe;
        };

        inline float4 LightingBasicDiffuse(SurfaceOutput o,
                                            fixed3 lightDir,
                                            fixed atten)
        {
            float difLight = max(0, dot(o.Normal, lightDir));
            float hLambert = difLight * 0.5 + 0.5;
            float3 ramp = tex2D(_RampTex, float2(hLambert, hLambert)).rgb;
            float4 col;
            col.rgb = o.Albedo * _LightColor0.rgb * ramp;
            col.a = o.Alpha;
            return col;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 c;
            c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
