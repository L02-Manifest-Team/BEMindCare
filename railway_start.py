#!/usr/bin/env python
"""
Railway startup script - handles PORT environment variable
"""
import os
import sys

if __name__ == "__main__":
    # Get port from environment (Railway sets this automatically)
    port = int(os.environ.get("PORT", 8000))
    
    # Debug info
    print(f">>> [RAILWAY] Starting BKMindCare API server")
    print(f">>> [RAILWAY] Port: {port}")
    print(f">>> [RAILWAY] Host: 0.0.0.0")
    
    # Check database URL
    db_url = os.environ.get("DATABASE_URL", "Not set")
    if db_url != "Not set":
        # Mask password in logs
        if "@" in db_url:
            parts = db_url.split("@")
            if len(parts) == 2:
                masked_url = parts[0].split("//")[0] + "//***@" + parts[1]
                print(f">>> [RAILWAY] DATABASE_URL: {masked_url}")
        else:
            print(f">>> [RAILWAY] DATABASE_URL: {db_url[:50]}...")
    else:
        print(">>> [WARNING] DATABASE_URL not set in environment variables!")
    
    # Import uvicorn after port is determined
    try:
        import uvicorn
        print(">>> [RAILWAY] Uvicorn imported successfully")
    except ImportError as e:
        print(f">>> [ERROR] Failed to import uvicorn: {e}")
        sys.exit(1)
    
    try:
        print(">>> [RAILWAY] Starting uvicorn server...")
        uvicorn.run(
            "app.main:app",
            host="0.0.0.0",
            port=port,
            log_level="info",
            access_log=True
        )
    except Exception as e:
        print(f">>> [ERROR] Failed to start server: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
