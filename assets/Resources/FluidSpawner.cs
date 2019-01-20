using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FluidSpawner : MonoBehaviour
{
    public GameObject fluidPrefab;

    public float waterSpawnDelay = 1.0f;
    public int maxObjects = 100;
    public float randomDist = 0.25f;
    public Vector2 initialVelocity;
    public bool continuous = true;

    private GameObject[] _waterNodes;
    private float _currentDelay;
    private int _nextWaterGameObjectIndex;

	void Start ()
    {
        _currentDelay = 0;
        _nextWaterGameObjectIndex = 0;
        _waterNodes = new GameObject[maxObjects];
    }
	
	void Update ()
    {
        _currentDelay += Time.deltaTime;
        if(_currentDelay >= waterSpawnDelay)
        {
            _currentDelay = 0;
            _nextWaterGameObjectIndex++;
            if(_nextWaterGameObjectIndex >= maxObjects)
            {
                _nextWaterGameObjectIndex = 0;
            }

            if (_waterNodes[_nextWaterGameObjectIndex] == null)
            {
                GameObject waterNode = _waterNodes[_nextWaterGameObjectIndex] = Instantiate(fluidPrefab, transform.position + new Vector3(Random.value * randomDist, Random.value * randomDist, Random.value * randomDist), Quaternion.identity);
                waterNode.GetComponent<Rigidbody2D>().velocity = initialVelocity;
                waterNode.layer = gameObject.layer;
            }
            else
            {
                GameObject waterNode = _waterNodes[_nextWaterGameObjectIndex];
                Rigidbody2D body = waterNode.GetComponent<Rigidbody2D>();
                body.velocity = initialVelocity;
                waterNode.transform.position = transform.position + new Vector3(Random.value * randomDist, Random.value * randomDist, Random.value * randomDist);
            }
        }
    }
}
