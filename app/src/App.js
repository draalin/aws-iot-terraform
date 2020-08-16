import React, { Component } from 'react';
import './App.css';

import Amplify from 'aws-amplify';
import { AWSIoTProvider } from '@aws-amplify/pubsub/lib/Providers';

Amplify.configure({
  Auth: {
    identityPoolId: process.env.REACT_APP_IDENTITY_POOL_ID,
    region: process.env.REACT_APP_REGION,
    userPoolId: process.env.REACT_APP_USER_POOL_ID,
    userPoolWebClientId: process.env.REACT_APP_USER_POOL_WEB_CLIENT_ID
  }
});

Amplify.addPluggable(new AWSIoTProvider({
  aws_pubsub_region: process.env.REACT_APP_REGION,
  aws_pubsub_endpoint: `wss://${process.env.REACT_APP_MQTT_ID}.iot.${process.env.REACT_APP_REGION}.amazonaws.com/mqtt`,
}));

Amplify.PubSub.subscribe('real-time-data').subscribe({
  next: data => console.log('Message received', data),
  error: error => console.error(error),
  close: () => console.log('Done'),
});

class App extends Component {
  render() {
    return (
      <div className="App">
        <h1>Realtime Data</h1>
      </div>
    );
  }
}

export default App;