import React from 'react';
import Home from './Home';
import {
  Routes,
  Route
} from 'react-router-dom';
import { TestUseCallback } from './TestUseCallback';
export function App() {
  return (
    <div>
      <Routes>
        <Route path='/' element={<Home />}></Route>
        <Route path='test-use-callback' element={<TestUseCallback />}></Route>
      </Routes>
    </div>
  );
}