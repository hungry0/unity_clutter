using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
public class UsingDepthMaps : MonoBehaviour {

    public Camera depthCamera;

    public Shader shader;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    public void OnPreRender()
    {
        depthCamera.depthTextureMode = DepthTextureMode.Depth;
        depthCamera.RenderWithShader(shader, "RenderType");
    }
}
