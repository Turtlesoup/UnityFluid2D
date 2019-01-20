Shader "Hidden/FluidMaskShader"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
		_BlurAmount ("Blur Amount", Range(0,1)) = 0.005
		_Threshold ("Threshold", Range(0,1)) = 0.1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float _BlurAmount;
			float _Threshold;

			float normalPDF(float x, float sigma)
			{
				return 0.39894*exp(-0.5*x*x / (sigma*sigma)) / sigma;
			}

			fixed4 frag (v2f o) : SV_Target
			{
				half4 col = tex2D(_MainTex, o.uv);

				// Apply blur
				const int mSize = 7;
				const int iter = (mSize - 1) / 2;

				for (int i = -iter; i <= iter; ++i)
				{
					for (int j = -iter; j <= iter; ++j)
					{
						col += tex2D(_MainTex, float2(o.uv.x + i * _BlurAmount, o.uv.y + j * _BlurAmount)) * normalPDF(float(i), 7);
					}
				}

				col /= mSize;

				// Thresholding
				if(((col.x + col.y + col.z) / 3) < _Threshold)
				{
					col = half4(0, 0, 0, 0);
				}
				else
				{
					col = half4(255, 255, 255, 255);
				}

				return col;
			}
			ENDCG
		}
	}
}
