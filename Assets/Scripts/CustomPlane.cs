using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.PlayerLoop;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshCollider))]
public class CustomPlane : MonoBehaviour
{
    private Mesh mesh;
    private Vector3[] vertices;
    private int[] triangles;
    private Vector2[] uvs;
    private Vector2 uvScale;
    
    [Header("Mesh Detail")]
    public int xSize = 10;
    public int zSize = 10;
    public bool originateMeshAtOrigin;
    public bool showGizmos = false;

    [Header("Perlin Noise Settings")]
    public bool addPerlinNoise = true;
    public float power = 2.0f;
    public float scale = 5.0f;
    private float offsetX = 100f;
    private float offsetZ = 100f;
    
    private float adjustedXPos;
    private float adjustedZPos;



    // Start is called before the first frame update
    void Start()
    {
        mesh = new Mesh();
        GetComponent<MeshFilter>().mesh = mesh;
        adjustedXPos = 0;
        adjustedZPos = 0;
        if (!originateMeshAtOrigin)
        {
            adjustedXPos = xSize / 2;
            adjustedZPos = zSize / 2;
        }
        
//These items used in Perlin Noise randomization
        offsetX = Random.Range(0, 999f);
        offsetZ = Random.Range(0, 999f);
        
        CreateShape();
        UpdateMesh();
     }

    void CreateShape()
    {
        vertices = new Vector3[(xSize + 1) * (zSize + 1)];
        uvs = new Vector2[vertices.Length];
         
        for (int i = 0, z = 0; z <= zSize; z++)
        {
            for (int x = 0; x <= xSize; x++)
            {
                vertices[i] = addPerlinNoise
                    ? new Vector3(x - adjustedXPos, GetPerlinNoiseHeight(x, z), z - adjustedZPos)
                    : new Vector3(x - adjustedXPos, 0, z - adjustedZPos);

                uvs[i] = new Vector2((float)x/xSize - adjustedXPos, (float)z/zSize - adjustedZPos);
                i++;
            }
        }

        triangles = new int[xSize * zSize * 6];
        int vert = 0;
        int tris = 0;

        for (int z = 0; z < zSize; z++)
        {
            for (int x = 0; x < xSize; x++)
            {
                triangles[tris + 0] = vert + 0;
                triangles[tris + 1] = vert + xSize + 1;
                triangles[tris + 2] = vert + 1;
                triangles[tris + 3] = vert + 1;
                triangles[tris + 4] = vert + xSize + 1;
                triangles[tris + 5] = vert + xSize + 2;

                vert++;
                tris += 6;
            }

            vert++;
        }
   }

    float GetPerlinNoiseHeight(int x, int z)
    {
        float xCoord = (float)x / xSize * scale + offsetX;
        float zCoord = (float)z / zSize * scale + offsetZ;

        return Mathf.PerlinNoise (xCoord, zCoord) * power;
    }
    

    void UpdateMesh()
    {
        mesh.Clear();
        mesh.vertices = vertices;
        mesh.triangles = triangles;
        mesh.uv = uvs;
        
        mesh.RecalculateNormals();

        MeshCollider thisMC = GetComponent<MeshCollider>();
        thisMC.sharedMesh = mesh;
    
    }
 
    private void OnDrawGizmos()
    {
        if (showGizmos)
        {
            if (vertices == null)
                return;

            Vector3 recalculatedXYZVertex = new Vector3();
            for (int i = 0; i < vertices.Length; i++)
            {
                recalculatedXYZVertex.x = vertices[i].x * transform.localScale.x;
                recalculatedXYZVertex.y = vertices[i].y * transform.localScale.y;
                recalculatedXYZVertex.z = vertices[i].z * transform.localScale.z;

                Gizmos.DrawSphere(recalculatedXYZVertex, .1f);
            }
        }
    }
}