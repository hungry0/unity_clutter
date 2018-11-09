using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthTextureCamera : MonoBehaviour {

    public Camera _camera;

    public RenderTexture _rt;

    Matrix4x4 sm = new Matrix4x4();

    void Start () {
        _camera.name = "DepthCamera";

        _camera.SetReplacementShader(Shader.Find("Unlit/WriteDepthMap"), "RenderType");

        sm.m00 = 0.5f;
        sm.m11 = 0.5f;
        sm.m22 = 0.5f;
        sm.m03 = 0.5f;
        sm.m13 = 0.5f;
        sm.m23 = 0.5f;
        sm.m33 = 1;

        _camera.orthographic = true;
        _camera.orthographicSize = 20;

        _camera.aspect = 1;
    }
	
	void Update () {
        _camera.Render();
        Matrix4x4 tm = GL.GetGPUProjectionMatrix(_camera.projectionMatrix, false) * _camera.worldToCameraMatrix;
        tm = sm * tm;

        Shader.SetGlobalMatrix("lightProjectionMatrix", tm);
        Shader.SetGlobalTexture("depthTexture", _rt);
    }
}
