using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
public class DepthTextureMgr : MonoBehaviour {

    public Camera depthCamera;
    public RenderTexture depthRT;
    public Shader shader;

    private Camera mainCamera;

    private Matrix4x4 lightMatrix;

	void Start () {
        mainCamera = Camera.main;


        depthCamera.targetTexture = depthRT;
        depthCamera.name = "depthCamera";
        depthCamera.orthographic = true;
        depthCamera.orthographicSize = 20;
        depthCamera.aspect = 1;

        depthCamera.SetReplacementShader(Shader.Find("Unlit/LightSpaceDistance"), "RenderType");
    }
	
	void Update () {
        depthCamera.Render();

        lightMatrix = GL.GetGPUProjectionMatrix(depthCamera.projectionMatrix, false) * depthCamera.worldToCameraMatrix;

        Shader.SetGlobalMatrix("cameraMatrix", mainCamera.worldToCameraMatrix);
        Shader.SetGlobalMatrix("lightMatrix", lightMatrix);

    }
}
