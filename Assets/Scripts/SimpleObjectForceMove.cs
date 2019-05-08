using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleObjectForceMove : MonoBehaviour
{
   public Rigidbody Ball;
   public float forceAmount = 20f;

    void Start()
    {
        Ball = GetComponent<Rigidbody>();
    }
 
    void Update(){  
        Vector3 movedir = new Vector3(Input.GetAxis ("Horizontal"),0, Input.GetAxis ("Vertical"));  
        Ball.AddForce (movedir*forceAmount);  
    }
}

