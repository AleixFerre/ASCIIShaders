using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoRotate : MonoBehaviour
{
    private float origHeight;
    private float _cosFloat = 0.0f;

    // Start is called before the first frame update
    void Start()
    {
        origHeight = this.transform.position.y;
    }

    void FixedUpdate()
    {
        var oldPosition = this.transform.position;

        _cosFloat += 0.04f;
        if (_cosFloat > 6.28319f)
            _cosFloat -= 6.28319f;

        this.transform.Rotate(Vector3.up, 2.5f);

        var value = (Mathf.Cos(_cosFloat) * 1.50f);

        this.transform.position = new Vector3(oldPosition.x,
            origHeight + value,
            oldPosition.z);
    }
}
