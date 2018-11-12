using UnityEngine;
public class DepthTextureMgr : MonoBehaviour {
    public Camera depthCamera;
    public RenderTexture depthRT;

    private Matrix4x4 lightMatrix;
    private Matrix4x4 sm = new Matrix4x4();

    void Start () {
        depthCamera.targetTexture = depthRT;
        depthCamera.name = "depthCamera";
//          depthCamera.orthographic = true;
//        depthCamera.orthographicSize = 10;
//        depthCamera.aspect = 1;

        depthCamera.SetReplacementShader(Shader.Find("Unlit/LightSpaceDistance"), "RenderType");

        sm.m00 = 0.5f;
        sm.m11 = 0.5f;
        sm.m22 = 0.5f;
        sm.m03 = 0.5f;
        sm.m13 = 0.5f;
        sm.m23 = 0.5f;
        sm.m33 = 1;
    }
	
	void Update () {
        depthCamera.Render();

        lightMatrix = GL.GetGPUProjectionMatrix(depthCamera.projectionMatrix, false) * depthCamera.worldToCameraMatrix;

        Shader.SetGlobalMatrix("global_cameraMatrix", depthCamera.worldToCameraMatrix);
        Shader.SetGlobalMatrix("global_lightMatrix", lightMatrix);
        Shader.SetGlobalTexture("global_depthTexture", depthRT);
    }
}
