// Adding Resources to API Gateway in AWS CDK
//We are going to create 2 endpoints for our API:
//todos with HTTP GET
//todos/{todoId} with HTTP DELETE

import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as cdk from 'aws-cdk-lib';
import * as path from 'path';


export class CdkStarterStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props)

    // ... rest

    //  define GET todos function
    const getTodosLambda = new lambda.Function(this, 'get-todos-lambda', {
      runtime: lambda.Runtime.NODEJS_16_X,
      handler: 'index.main',
      code: lambda.Code.fromAsset(path.join(__dirname, '/../src/get-todos')),
    });

    // add a /todos resource
    const todos = api.root.addResource('todos');

    //  integrate GET /todos with getTodosLambda
    todos.addMethod(
      'GET',
      new apigateway.LambdaIntegration(getTodosLambda, {proxy: true}),
    );
  }
}
