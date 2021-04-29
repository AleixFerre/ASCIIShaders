///////////////////////////////////////////////////
// ASCII SHADER by Johan Munkestam 2008 and 2013 //
///////////////////////////////////////////////////

// http://unity3d.com/support/documentation/Components/SL-Shader.html
Shader "AsciiZarkow"
{
  // http://unity3d.com/support/documentation/Components/SL-Properties.html
  Properties
  {
    _MainTex("Base (RGB)", 2D) = "white" {}
  }

  CGINCLUDE
  #include "UnityCG.cginc"

  uniform sampler2D _MainTex;
  
float charWidth = 9;
float charHeight = 10;

float monitorWidthMultiplier = 1.0f;
float monitorHeightMultiplier = 1.0f;


/*********** TEXTURES ***************/
sampler texture1 : register(s0);
sampler texture2 : register(s1);

sampler2D BracketSampler;

sampler2D AndSampler;

sampler2D DollarSampler;

sampler2D RSampler;

sampler2D PSampler;

sampler2D AsterixSampler;

sampler2D PlusSampler;

sampler2D TildeSampler;

sampler2D MinusSampler;

sampler2D DotSampler;

struct VertexShaderInput
{
     float4 Position : POSITION;  // already transformed position.
     float2 UV : TEXCOORD0; // texture coordinates passed in
};

struct VertexShaderOutput
{
    float4 Position : POSITION; // just need to copy the position of the VS input in this one.
    float2 UV : TEXCOORD0; // first set of tex coords.
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output = (VertexShaderOutput)0;

    //float4 worldPosition = mul(input.Position, World);
    //float4 viewPosition = mul(worldPosition, View);
    //output.Position = mul(viewPosition, Projection);

    // copy the existing position into the output.
    output.Position = input.Position;
    output.UV = input.UV;

    return output;
}

float4 PixelShaderFunction(v2f_img i) : COLOR // was float2 texCoord : TEXCOORD0) : COLOR0
{
  // float4 tex1 = tex2D(_MainTex, texCoord); // input.UV
  
  // get coordinates of this pxl
  float2 texCoord = i.uv;

  // we need to re-clamp this pixel coordinate to a new value, representing a image divided by char-size.
  int locX = (int)(texCoord.x * monitorWidthMultiplier);
  int locY = (int)(texCoord.y * monitorHeightMultiplier);
  
  float2 grayPixelPos;
  grayPixelPos.x = locX / monitorWidthMultiplier;
  grayPixelPos.y = locY / monitorHeightMultiplier;

  // get pixel colors
  float3 pixel = tex2D(_MainTex, grayPixelPos).rgb;

  // gray scale it.
  float gray = (pixel.r + pixel.g + pixel.b) / 3;

  float4 tex1 = float4(0, 0, 0, 0); // force color to bright green like old style monitors.
  
  // set green, if gray is above 0.0f)
  if (gray > 0.0f)
  {
    
	// tex1.rgb = float3(gray, gray, gray); // force color to bright green like old style monitors.

    // check gray-level to determine which char to show...
    float step = 11.0f - (gray * 11.0f); // invert char mapping for brightness, looks better

    float4 tex2 = float4(0, 0, 1, 1);

	if (step < 0.5f)
	{
		tex2 = tex2D(BracketSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		//tex1.rgb = float3(0.15f, 0, 0);
	}
	else if (step < 1.5f)
	{
		tex2 = tex2D(AndSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		//tex1.rgb = float3(0.30f, 0, 0);
	}
	else if (step < 2.5f)
	{
		tex2 = tex2D(DollarSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		//tex1.rgb = float3(0.45f, 0, 0);
	}
	else if (step < 3.5f)
	{
		tex2 = tex2D(RSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		//tex1.rgb = float3(0.60f, 0, 0);
	}
	else if (step < 4.5f)
	{
		tex2 = tex2D(PSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		//tex1.rgb = float3(0.75f, 0, 0);
	}
	else if (step < 5.5f)
	{
		tex2 = tex2D(AsterixSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		//tex1.rgb = float3(1.0f, 0, 0.15f);
		tex2.r = tex2.a;
	}
	else if (step < 6.5f)
	{
		//tex2 = tex2D(PlusSampler, float2(texCoord.x * charCountWide, texCoord.y * charCountTall));
		tex2 = tex2D(PlusSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		// tex1.rgb = float3(0, 0, 0.30f);
		//tex2.b = 0.75f;
	}
	else if (step < 7.5f)
	{
		tex2 = tex2D(TildeSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		//tex1.rgb = float3(0, 0, 0.45f);
		tex2.b = 0.75f;
	}
	else if (step < 8.5f)
	{
		tex2 = tex2D(MinusSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		//tex1.rgb = float3(0, 0, 0.60f);
	}
	else if (step < 9.5f)
	{
		tex2 = tex2D(DotSampler, float2(texCoord.x * monitorWidthMultiplier, texCoord.y * monitorHeightMultiplier));
		//tex1.rgb = float3(0, 0, 0.75f);
	}
	else
	{   // blank
		tex2.a = 0.0f;
		// tex1.rgb = float3(0.1f, 0, 0);
	}

    //set used chars alpha to cut letters into the rendered main texture...
    //tex1.g = tex2.a;
    tex1.g = tex2.a;
    
    // tex1.r = ((int)step) / 11.0f;
	//tex1.r = texCoord.x;
	
    //tex1.b = texCoord.x / 1920.0f;
    
    // tex1.rgb = float3(gray, gray, gray);
  }


  return tex1;
}

  ENDCG

  // Techniques (http://unity3d.com/support/documentation/Components/SL-SubShader.html).
  SubShader
  {
    // Tags (http://docs.unity3d.com/Manual/SL-CullAndDepth.html).
    ZTest Always
    Cull Off
    ZWrite Off
    Fog { Mode off }

    // Pass 0: Normal
    Pass
    {
      CGPROGRAM
      #pragma glsl
      #pragma fragmentoption ARB_precision_hint_fastest
      #pragma target 3.0
      #pragma vertex vert_img
      #pragma fragment PixelShaderFunction
      ENDCG      
    }

  }

  Fallback off
}