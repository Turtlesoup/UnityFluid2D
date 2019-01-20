using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FluidShader : MonoBehaviour
{
    public Material fluidMaterial;
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, fluidMaterial);
    }
}
