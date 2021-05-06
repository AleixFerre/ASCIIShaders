// Shader ASCII: Shader d'espai imatge que transforma els píxels de la pantalla en caracters ASCII, mantenint el color del original del píxel
// Creat per Aleix Ferré Juan, Joel Pérez Abad i Eric Joaquin Villena Ninapaitán

Shader "NPR/AsciiShader"
{
    Properties
    {
        _MainTex ("Base", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always Fog { Mode off }

        Pass
        {
            // Directivas pragma
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment pixelShaderFunction

            #include "UnityCG.cginc"
               
            // Vertex Input : position i UV cordinate
            struct vertexInput
            {
                float4 position : POSITION;  
                float2 uv : TEXCOORD0;
            };

            // Vertex Output : position i UV cordinate
            struct vertexOutput
            {
                float4 position : POSITION; 
                float2 uv : TEXCOORD0;
            };

            uniform sampler2D _MainTex;
            
            // Mida caracters ASCII
            float charWidth = 9.0f;
            float charHeight = 10.0f;

            float screenWidthMultiplier = 1.0f;
            float screenHeightMultiplier = 1.0f;

            // Texturas
            sampler texture1 : register(s0);
            sampler texture2 : register(s1);

            sampler2D andSampler;
            sampler2D asterixSampler;
            sampler2D bracketSampler;
            sampler2D dollarSampler;
            sampler2D dotSampler;
            sampler2D minusSampler;
            sampler2D pSampler;
            sampler2D plusSampler;
            sampler2D rSampler;
            sampler2D tildeSampler;

            vertexOutput VertexShaderFunction(vertexInput input)
            {
                vertexOutput output = (vertexOutput) 0;

                // Copiem la posició existent en l'output
                output.position = input.position;
                output.uv = input.uv;

                return output;
            }

            float4 pixelShaderFunction(v2f_img i) : COLOR
            {
                // Obtenim les coordenades del píxel (coordena UV)
                float2 texCoordPxl = i.uv;

                // Fixem aquesta coordenada de píxel a un nou valor, que representa una imatge dividida per la grandària del caràcter.
                int locX = (int)(texCoordPxl.x * screenWidthMultiplier);
                int locY = (int)(texCoordPxl.y * screenHeightMultiplier);

                float2 grayPixelPos;
                grayPixelPos.x = locX / screenWidthMultiplier;
                grayPixelPos.y = locY / screenHeightMultiplier;

                // Obtenim el color del píxel
                float3 pixelColor = tex2D(_MainTex, grayPixelPos).rgb;

                // Obtenim el valor en escala de grisos del píxel
                float grayValue = (pixelColor.r + pixelColor.g + pixelColor.b) / 3;

                float4 texOutput = float4(0, 0, 0, 0); // textura que acabarem mostrant

                // Si no es completament obscur
                if (grayValue > 0.0f)
                {
                    // Invertim el mapping del caracter per que es vegi millor
                    float stepInvChar = 11.0f - (grayValue * 11.0f); 

                    float4 tex2 = float4(0, 0, 0, 1); // textura del mapejat del caracter al pixel 

                    // Depenent del valor de gris, mostrarem un caracter o altre fent un mapejat de la textura al pixel
                    if (stepInvChar < 0.5f)
                    {
                        tex2 = tex2D(bracketSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else if (stepInvChar < 1.5f)
                    {
                        tex2 = tex2D(andSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else if (stepInvChar < 2.5f)
                    {
                        tex2 = tex2D(dollarSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else if (stepInvChar < 3.5f)
                    {
                        tex2 = tex2D(rSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else if (stepInvChar < 4.5f)
                    {
                        tex2 = tex2D(pSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else if (stepInvChar < 5.5f)
                    {
                        tex2 = tex2D(asterixSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else if (stepInvChar < 6.5f)
                    {
                        tex2 = tex2D(plusSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else if (stepInvChar < 7.5f)
                    {
                        tex2 = tex2D(tildeSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else if (stepInvChar < 8.5f)
                    {
                        tex2 = tex2D(minusSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else if (stepInvChar < 9.5f)
                    {
                        tex2 = tex2D(dotSampler, float2(texCoordPxl.x * screenWidthMultiplier, texCoordPxl.y * screenHeightMultiplier));
                    }
                    else
                    {   // En blanc
                        tex2.a = 0.0f;
                    }

                    // Esteblim els valors RGB del la nova textura tot utilitzant el valor Alpha de la textura previament calculat
                    texOutput.rgb = float3(pixelColor.r * tex2.a, pixelColor.g * tex2.a, pixelColor.b * tex2.a);

                  }

                  return texOutput;
            }
            ENDCG
        }
    }
}
