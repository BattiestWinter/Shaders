Shader "MyShader/BasicShader"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
    }

    SubShader
    {
        //Pass: Lo que se va a estar compilando
        Pass
        {
            CGPROGRAM
            //Verifica errores en el vertex y fragment shader
            #pragma vertex vertexShader
            #pragma fragment fragmentShader
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            
            //Vertex Input
            struct vertexInput
            {
                float4 vertex:POSITION;
                float2 uv:TEXCOORD0;
            };

            struct vertexOutput
            {
                //Cambiar de local a view space
                float4 position:SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            vertexOutput vertexShader(vertexInput i)
            {
                vertexOutput o;
                //Suma las tres matrices para que el objeto no se deforme
                o.position = UnityObjectToClipPos(i.vertex); 
                /*o.uv = i.uv;
                o.uv = (i.uv * _MainTex_ST.xy + _MainTex_ST.zw);*/
                o.uv = TRANSFORM_TEX(i.uv, _MainTex);
                return o;
            }

            fixed4 fragmentShader(vertexOutput i) : SV_Target
            {
                //sample texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }

            ENDCG
        }
    }

    //Si no funciona ninguno de los shaders, establece el dafault
    Fallback "Default"
}
