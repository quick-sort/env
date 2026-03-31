from qdrant_client import QdrantClient, models

client = QdrantClient(...)

client.create_collection(
    collection_name="your_coll",
    vectors_config=models.VectorParams(
        size=1024,
        distance=models.Distance.COSINE,   # BGE-M3 推荐 Cosine
        on_disk=True                       # 原始向量放磁盘（mmap）
    ),
    hnsw_config=models.HnswConfigDiff(
        m=16,               # 平衡精度/内存
        ef_construct=100,
        on_disk=True        # HNSW 索引也放磁盘
    ),
    quantization_config=models.ScalarQuantization(
        scalar=models.ScalarQuantizationConfig(
            type=models.ScalarType.INT8,
            quantile=0.99,
            always_ram=True     # 量化后向量常驻内存（≈20GB 总共）
        )
    ),
    optimizers_config=models.OptimizersConfigDiff(
        default_segment_number=2,
        max_segment_size=5000000
    )
)
