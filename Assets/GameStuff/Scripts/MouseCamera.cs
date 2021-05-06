using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseCamera : MonoBehaviour {
    private float xRotation = 0f;

    public float mouseSensibility = 100f;
    public Transform playerTransform;

    void Start() {
        Cursor.lockState = CursorLockMode.Locked;
    }

    void Update() {
        float mouseX = Input.GetAxisRaw("Mouse X"); // GetAxisRaw
        float mouseY = Input.GetAxisRaw("Mouse Y"); // GetAxisRaw

        mouseX *= mouseSensibility * Time.deltaTime;
        mouseY *= mouseSensibility * Time.deltaTime;

        xRotation -= mouseY;
        xRotation = Mathf.Clamp(xRotation, -90f, 90f);

        transform.localRotation = Quaternion.Euler(xRotation, 0, 0);
        playerTransform.Rotate(Vector3.up * mouseX);
    }

}