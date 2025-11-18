#!/data/data/com.termux/files/usr/bin/bash
# Deploy to cloud from mobile

PROVIDER=${1:-heroku}

echo "Deploying to $PROVIDER..."

case $PROVIDER in
  heroku)
    echo "Deploying to Heroku..."
    git push heroku main
    ;;
  railway)
    echo "Deploying to Railway..."
    railway up
    ;;
  vercel)
    echo "Deploying to Vercel..."
    vercel --prod
    ;;
  *)
    echo "Unknown provider: $PROVIDER"
    echo "Supported: heroku, railway, vercel"
    exit 1
    ;;
esac

echo "Deployment complete!"
