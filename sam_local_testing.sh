sam local invoke "RecommendGoalsFunction" \
    --template-file infrastructure/recommendations-svc.yml \
    -e recommendations_svc/tests/unit/lambda_recommened_goals/testEvent.json \
    --env-vars sam_local_invoke_env.json

sam local invoke "RecommendActionsFunction" \
    --template-file infrastructure/recommendations-svc.yml \
    -e recommendations_svc/tests/unit/lambda_recommened_actions/testEvent.json \
    --env-vars sam_local_invoke_env.json
