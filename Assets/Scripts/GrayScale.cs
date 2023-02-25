using UnityEngine;

[ExecuteInEditMode]
public class GrayScale : MonoBehaviour
{
    public Shader currentShader;
    public float grayScaleAmount;
    private Material currentMaterial;
    
    Material Material
    {
        get
        {
            if (currentMaterial == null)
            {
                currentMaterial = new Material(currentShader);
                currentMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return currentMaterial;
        }
    }

    void start() 
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
        if (!currentShader && !currentShader.isSupported)
        {
            enabled = false;
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest) 
    {
        if (currentShader != null)
        {
            Material.SetFloat("_LuminosityAmount", grayScaleAmount);
            Graphics.Blit(src, dest, currentMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

    void Update() 
    {
        grayScaleAmount = Mathf.Clamp(grayScaleAmount, 0.0f, 1.0f);
    }

    void OnDisable() {
        if (currentMaterial)
        {
            DestroyImmediate(currentMaterial);
        }
    }
}
