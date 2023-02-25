using UnityEngine;

[ExecuteInEditMode]
public class NightVision : MonoBehaviour
{
    public Shader currentShader;
    public float contrast = 2;
    public float brightness = 1f;
    public Color nightVisionColor = Color.white;
    public Texture2D vignetteTexture;
    public Texture2D scanlineTexture;
    public float scanlineAmount = 4f;
    public Texture2D noiseTexture;
    public float noiseXSpeed;
    public float noiseYSpeed;
    public float distortion;
    public float scale;
    private float randomValue;

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
            Material.SetFloat("_Contrast", contrast);
            Material.SetFloat("_Brightness", brightness);
            Material.SetColor("_NightVisionColor", nightVisionColor);
            Material.SetFloat("_RandomValue", randomValue);
            Material.SetFloat("_Distortion", distortion);
            Material.SetFloat("_Scale", scale);
            if (vignetteTexture)
            {
                Material.SetTexture("_VignetteTex", vignetteTexture);
            }
            if (scanlineTexture)
            {
                Material.SetTexture("_ScanlineTex", scanlineTexture);
                Material.SetFloat("_ScanlineAmount", scanlineAmount);
            }
            if (noiseTexture)
            {
                Material.SetTexture("_NoiseTex", noiseTexture);
                Material.SetFloat("_NoiseXSpeed", noiseXSpeed);
                Material.SetFloat("_NoiseYSpeed", noiseYSpeed);
            }

            Graphics.Blit(src, dest, currentMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

    void Update()
    {
        contrast = Mathf.Clamp(contrast, 0f,4f);
        brightness = Mathf.Clamp(brightness, 0f,2f);
        randomValue = Random.Range(-1f,1f);
        distortion = Mathf.Clamp(distortion, -1f,1f);
        scale = Mathf.Clamp(scale, 0f,3f);
    }

    void OnDisable() 
    {
        if (currentMaterial)
        {
            DestroyImmediate(currentMaterial);
        }
    }

}
