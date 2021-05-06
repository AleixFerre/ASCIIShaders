using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenu : MonoBehaviour {

    public GameObject canvas;

    public MouseCamera mouse;
    public PlayerController controller;

    public void PlayGame() {
        Debug.Log("Començant a jugar!");
        canvas.SetActive(false);
        mouse.enabled = true;
        controller.enabled = true;
    }

    public void ExitGame() {
        Debug.Log("Adeu!");
#if UNITY_EDITOR 
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }

}