using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour {
    private const float gravity = -40f;
    private Vector3 velocity;
    private bool onGround = true;

    public float playerSpeed = 5f;
    public float jumpHigh = 1f;
    public CharacterController controller;
    public Transform groundCheck;
    public float radiusCollision = 0.1f;
    public LayerMask maskLayer;

    public GameObject canvas;
    public MouseCamera mouse;

    void Update() {

        if (Input.GetKeyDown(KeyCode.Escape)) {
            mouse.enabled = false;
            canvas.SetActive(true);
            enabled = false;
            Cursor.lockState = CursorLockMode.None;
            return;
        }

        onGround = Physics.CheckSphere(groundCheck.position, radiusCollision, maskLayer);

        if (onGround && velocity.y > 0) {
            velocity.y = radiusCollision * -20f;
        }

        float transformX = Input.GetAxisRaw("Horizontal"); // GetAxisRaw
        float transformY = Input.GetAxisRaw("Vertical"); // GetAxisRaw

        Vector3 direction = transform.right * transformX + transform.forward * transformY;

        controller.Move(direction * playerSpeed * Time.deltaTime);

        if (Input.GetButtonDown("Jump") && onGround) {
            velocity.y = Mathf.Sqrt(jumpHigh * -2f * gravity);
        }

        velocity.y += gravity * Time.deltaTime;

        controller.Move(velocity * Time.deltaTime);
    }

    void OnDrawGizmos() {
        Gizmos.DrawWireSphere(groundCheck.position, radiusCollision);
    }
}