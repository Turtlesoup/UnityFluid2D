Shader "Hidden/FluidShader"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
		[HideInInspector] _maskTexture ("maskTexture", 2D) = "white" {}
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
			sampler2D _maskTexture;
			static int _range = 3;
			static float _thickness = 0.0015f;

			fixed4 frag (v2f o) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, o.uv);
				fixed4 maskCol = tex2D(_maskTexture, o.uv);

				// If the mask is transparent then render the fragment as normal
				// HACK: checking for alpha means objects can be placed "behind" the water by making them just slightly (un-noticably) transparent.
				if(maskCol.a == 0 || col.a > 0.999)
				{
					return col;
				}
				else
				{
					// tint blue at 50% opacity
					col *= fixed4(0.0f, 0.75f, 1.0f, 0.5f);

					int minDistance = _range + 1;
					for (int i = -_range; i <= _range; ++i)
					{
						for (int j = -_range; j <= _range; ++j)
						{
							if(tex2D(_maskTexture, float2(o.uv.x + i * _thickness, o.uv.y + j * _thickness)).a == 0)
							{
								if(abs(i) < minDistance)
								{
									minDistance = abs(i);
								}
								
								if(abs(j) < minDistance)
								{
									minDistance = abs(j);
								}
							}
						}
					}

					if(minDistance < _range + 1)
					{
						float intensity = 1.0f;
						float offset = (1 - ((float)minDistance / (float)_range)) * intensity;
						col += fixed4(offset, offset, offset, offset * 0.5f);
					}

					return col;
				}
			}
			ENDCG
		}
	}
}
