using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FluidMaskShader : MonoBehaviour
{
    RenderTexture mask;

    public Material maskMaterial;
    public Material fluidMaterial;
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // Create mask render texture if it has not yet been created
        if(mask == null)
        {
            mask = new RenderTexture(src.width, src.height, src.depth);
            fluidMaterial.SetTexture(Shader.PropertyToID("_maskTexture"), mask);
        }

        // Update the mask render texture
        Graphics.Blit(src, mask, maskMaterial);
    }
}
