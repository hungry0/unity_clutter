using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
public class DepthTextureMgr : MonoBehaviour {

    public Camera depthCamera;

    public Shader shader;

	void Start () {
		
	}
	
	void Update () {
		
	}

    public void OnPreRender()
    {
        depthCamera.depthTextureMode = DepthTextureMode.Depth;
        depthCamera.RenderWithShader(shader, "RenderType");
    }
}
