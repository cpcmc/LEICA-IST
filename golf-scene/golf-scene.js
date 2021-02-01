/*
    VARIAVEIS GLOBAIS
*/

import * as THREE from 'https://unpkg.com/three@0.120.1/build/three.module.js';
import { OrbitControls } from 'https://unpkg.com/three@0.120.1/examples/jsm/controls/OrbitControls.js';

var renderer;
var scene, camera;
var golfBall, golfFlag, grass;
var directionalLight, pointLight;
var tBall = 0;

var clock = new THREE.Clock();

var isWireframeOn = false;
var isLightCalcOn = true;
var updatedWireframe = false;
var updatedMaterial = false;
var updatedReset = false;
var updatedPointLight = false;
var updatedDirectionalLight = false;
var pause = false;

var pauseScene, pauseCamera;

/*
    OBJETOS
*/

function createGrass() {

  let _grassMap = new THREE.TextureLoader().load( "img/grass-pattern.png" );
  _grassMap.wrapS = THREE.RepeatWrapping;
  _grassMap.wrapT = THREE.RepeatWrapping;
  _grassMap.repeat.set( 32, 32 );

  let _grassBM = new THREE.TextureLoader().load( "img/grass-bmap.png" );
  _grassBM.wrapS = THREE.RepeatWrapping;
  _grassBM.wrapT = THREE.RepeatWrapping;
  _grassBM.repeat.set( 32, 32 );

  let _grassGeometry = new THREE.PlaneGeometry(50, 50, 32);

  //basic material with map
  let _grassBasic = new THREE.MeshBasicMaterial({ color: 0x00ff00, map: _grassMap});
  //phong material with map and bumpmap
  let _grassPhong = new THREE.MeshPhongMaterial( { color: 0x00ff00, specular: 0xFFFFFF, bumpMap: _grassBM, map: _grassMap});

  grass = new THREE.Mesh( _grassGeometry, _grassPhong);
  grass.rotateX( -90 * Math.PI /180);

  grass.basicMaterial = _grassBasic;
  grass.phongMaterial = _grassPhong;

  grass.basicMaterial.side = THREE.DoubleSide;
  grass.phongMaterial.side = THREE.DoubleSide;

  scene.add(grass);

  grass.reset = () => {
    grass.material = grass.phongMaterial;
    grass.material.wireframe = false;
  }

}

function createGolfBall() {

  let _golfBallTexture = new THREE.TextureLoader().load( "img/ball-bmap.png" );
  const GOLF_BALL_RADIUS = 1;

  let _golfBallGeometry = new THREE.SphereGeometry(GOLF_BALL_RADIUS, 32, 32);
  let _golfBallBasic = new THREE.MeshBasicMaterial({ color : 0xffffff});
  let _golfBallPhong = new THREE.MeshPhongMaterial({ 
                            color: 0xffffff, 
                            specular: 0xFFFF00,
                            shininess: 500,
                            bumpMap: _golfBallTexture,
                            bumpScale: 0.1
                          });
  golfBall = new THREE.Mesh( _golfBallGeometry, _golfBallPhong);

  

  //attributes
  golfBall.basicMaterial = _golfBallBasic;
  golfBall.phongMaterial = _golfBallPhong;

  golfBall.radius = GOLF_BALL_RADIUS;

  golfBall.movement = true;

  golfBall.v0 = 15;
  golfBall.angle = 30 * Math.PI/180;
  golfBall.g = 9.8;
  golfBall.timeDirection = +1;
  golfBall.x0 = -15;
  golfBall.y0 = golfBall.radius;
  golfBall.z0 = -5;

  golfBall.position.set(golfBall.x0, golfBall.y0, golfBall.z0);

  scene.add(golfBall);

  golfBall.reset = () => {
    golfBall.material = golfBall.phongMaterial;
    golfBall.material.wireframe = false;
    golfBall.position.set(golfBall.x0, golfBall.y0, golfBall.z0);
    tBall = 0;
    golfBall.timeDirection = +1;

    golfBall.movement = true;
  }
}

function createGolfFlag(position) {
  
  golfFlag = new THREE.Object3D();

  const POLE_RADIUS_TOP = 0.1;
  const POLE_RADIUS_BOTTOM = 0.1;
  const POLE_HEIGHT = 10;
  const POLE_RADIAL_SEGMENTS = 16;
  const POLE_HEIGHT_SEGMENTS = 16;
  let _poleGeometry = new THREE.CylinderGeometry(POLE_RADIUS_TOP, POLE_RADIUS_BOTTOM, POLE_HEIGHT, POLE_RADIAL_SEGMENTS, POLE_HEIGHT_SEGMENTS);
  let _poleBasicMaterial = new THREE.MeshBasicMaterial();
  let _polePhongMaterial = new THREE.MeshPhongMaterial();
  let _pole = new THREE.Mesh(_poleGeometry, _polePhongMaterial);

  golfFlag.pole = _pole;
  golfFlag.pole.basicMaterial = _poleBasicMaterial;
  golfFlag.pole.phongMaterial = _polePhongMaterial;
  
  golfFlag.add(_pole);

  const FLAG_RADIUS_TOP = 2;
  const FLAG_RADIUS_BOTTOM = 2;
  const FLAG_HEIGHT = 0.2;
  const FLAG_RADIAL_SEGMENTS = 3;
  const FLAG_HEIGHT_SEGMENTS = 1;

  const TRIANGLE_SIDE = Math.sqrt( (2 * Math.pow(FLAG_RADIUS_TOP, 2)) - (2 * Math.pow(FLAG_RADIUS_TOP, 2) * Math.cos(360 / 3 * Math.PI / 180))); 

  let _flagGeometry = new THREE.CylinderGeometry(FLAG_RADIUS_TOP, FLAG_RADIUS_BOTTOM, FLAG_HEIGHT, FLAG_RADIAL_SEGMENTS, FLAG_HEIGHT_SEGMENTS);
  let _flagBasicMaterial = new THREE.MeshBasicMaterial( { color: 0xFF0000});
  let _flagPhongMaterial = new THREE.MeshPhongMaterial( { color: 0xFF0000});
  let _flag = new THREE.Mesh(_flagGeometry, _flagPhongMaterial);
  
  _flag.rotateX(90 * Math.PI/180);
  _flag.rotateY(90 * Math.PI/180);

  _flag.position.set(Math.sqrt( Math.pow(FLAG_RADIUS_TOP,2) - Math.pow(TRIANGLE_SIDE / 2,2)), POLE_HEIGHT / 2 - TRIANGLE_SIDE / 2, 0);

  golfFlag.flag = _flag;
  golfFlag.flag.basicMaterial = _flagBasicMaterial;
  golfFlag.flag.phongMaterial = _flagPhongMaterial;

  golfFlag.add(_flag);

  golfFlag.position.set(position.x, position.y + POLE_HEIGHT / 2, position.z);

  golfFlag.movement = true;

  const FLAG_ANGULAR_VELOCITY = 80 * Math.PI / 180;

  golfFlag.angularVelocity = FLAG_ANGULAR_VELOCITY;

  scene.add(golfFlag);

  golfFlag.reset = () => {
    golfFlag.pole.material = golfFlag.pole.phongMaterial;
    golfFlag.pole.material.wireframe = false;
    golfFlag.flag.material = golfFlag.flag.phongMaterial;
    golfFlag.flag.material.wireframe = false;
    golfFlag.movement = true;
    golfFlag.rotation.y = 90 * Math.PI/180;
    
  }

}

function createDirectionalLight(position) {
  const DIR_LIGHT_COLOR = 0xFFFFFF;
  const DIR_LIGHT_INTENSITY = 1;
  directionalLight = new THREE.DirectionalLight(DIR_LIGHT_COLOR, DIR_LIGHT_INTENSITY);
  directionalLight.position.copy(position);
  scene.add(directionalLight);
}

function createPointLight(position) {
  const POINT_LIGHT_COLOR = 0xFFFF00;
  const POINT_LIGHT_INTENSITY = 0.7;
  const POINT_LIGHT_DISTANCE = 0;
  const POINT_LIGHT_DECAY = 2;
  pointLight = new THREE.PointLight(POINT_LIGHT_COLOR, POINT_LIGHT_INTENSITY, POINT_LIGHT_DISTANCE, POINT_LIGHT_DECAY);
  pointLight.position.copy(position);
  scene.add(pointLight);
}

function createSkybox() {
  let loader = new THREE.CubeTextureLoader();
  let landscape = loader.load([
    'img/cubemap/px.png',
    'img/cubemap/nx.png',
    'img/cubemap/py.png',
    'img/cubemap/ny.png',
    'img/cubemap/pz.png',
    'img/cubemap/nz.png',
  ]);
  scene.background = landscape;
}



/*
    CENA E CAMARAS
*/
function createScene() {
  scene = new THREE.Scene();
  createCamera(new THREE.Vector3(0, 10, 25));    //x, y, z

  createSkybox();
  createDirectionalLight(new THREE.Vector3(25, 25, 25));
  createPointLight(new THREE.Vector3(-10, 10, 10));
  createGrass();
  createGolfBall();
  createGolfFlag(new THREE.Vector3(5, 0, 0));
}

function createPause() {
  let width = window.innerWidth;
  let height = window.innerHeight;

  pauseScene = new THREE.Scene();
  pauseCamera = new THREE.OrthographicCamera(-width/2, width/2, height/2, -height/2, 0, 30 );

  let pauseCanvas = document.createElement('canvas');

  pauseCanvas.width = width;
  pauseCanvas.height = height;

  let pauseMap = pauseCanvas.getContext('2d');
  pauseMap.font = "Normal 100px Arial";
  pauseMap.textAlign = 'center';
  pauseMap.fillStyle = "rgb(0,0,0)";
  pauseMap.fillText('PAUSA', width / 2, height / 2 + 100/2);

  let pauseTexture = new THREE.Texture(pauseCanvas) 
  pauseTexture.needsUpdate = true;

  let material = new THREE.MeshBasicMaterial( {map: pauseTexture} );
  material.transparent = true;

  let planeGeometry = new THREE.PlaneGeometry( width, height );
  let plane = new THREE.Mesh( planeGeometry, material );
  pauseScene.add( plane );
}

function createCamera(position) {
  let fov = 50;
  let aspect = window.innerWidth / window.innerHeight;
  let near = 1;
  let far = 2000;

  camera = new THREE.PerspectiveCamera(fov, aspect, near, far);
  camera.position.copy(position);
  camera.lookAt(scene.position);

  let controls = new OrbitControls(camera, renderer.domElement);
  controls.target.set(0, 0, 0);
  controls.update();
}



/*
    EVENTOS
*/
function onKeyDown(e) {
  switch (e.keyCode) {
    case 68: //d
      updatedDirectionalLight = true;
      break;
    case 80: //p
      updatedPointLight = true;
      break;
    case 66: //b
      golfBall.movement = !golfBall.movement;
      break;
    case 87: //w
      updatedWireframe = true;
      break;
    case 73: //i
      updatedMaterial = true;
      break;
    case 82: //r
      updatedReset = true;
      break;
    case 83: //s
      pause = !pause;
      break;
  }
}

function onWindowResize() {
  let aspect = window.innerWidth / window.innerHeight;

  camera.aspect = aspect;
  camera.updateProjectionMatrix();

  if(pause) createPause();

  renderer.setSize(window.innerWidth, window.innerHeight);
}

/*
    ANIMACAO
*/

function animateGolfFlag(delta) {
  golfFlag.rotateY( golfFlag.angularVelocity * delta );
}

function animateGolfBall(delta) {
  if(golfBall.movement) {
    let newt = tBall + delta * golfBall.timeDirection;
    let newx = golfBall.x0 + golfBall.v0 * newt * Math.cos(golfBall.angle);
    let newy = golfBall.y0 + golfBall.v0 * newt * Math.sin(golfBall.angle) - 0.5 * golfBall.g * Math.pow(newt, 2);
    if ( newy < golfBall.radius) {
      golfBall.timeDirection = -golfBall.timeDirection;
      return;
    }
    tBall = newt;
    golfBall.position.x = newx;
    golfBall.position.y = newy;
  }
}

function updateWireframe(){
  isWireframeOn = !isWireframeOn;

  grass.material.wireframe = isWireframeOn;
  grass.basicMaterial.wireframe = isWireframeOn;
  grass.phongMaterial.wireframe = isWireframeOn;

  golfBall.material.wireframe = isWireframeOn;
  golfBall.basicMaterial.wireframe = isWireframeOn;
  golfBall.phongMaterial.wireframe = isWireframeOn;

  golfFlag.pole.material.wireframe = isWireframeOn;
  golfFlag.pole.basicMaterial.wireframe = isWireframeOn;
  golfFlag.pole.phongMaterial.wireframe = isWireframeOn;

  golfFlag.flag.material.wireframe = isWireframeOn;
  golfFlag.flag.basicMaterial.wireframe = isWireframeOn;
  golfFlag.flag.phongMaterial.wireframe = isWireframeOn;

  updatedWireframe = false;
}

function updateMaterial(){
  isLightCalcOn = !isLightCalcOn;

  grass.material = isLightCalcOn ? grass.phongMaterial : grass.basicMaterial;
  golfBall.material = isLightCalcOn ? golfBall.phongMaterial : golfBall.basicMaterial;
  golfFlag.pole.material = isLightCalcOn ? golfFlag.pole.phongMaterial : golfFlag.pole.basicMaterial;
  golfFlag.flag.material = isLightCalcOn ? golfFlag.flag.phongMaterial : golfFlag.flag.basicMaterial;
  
  updatedMaterial = false;
}

function updateDirectionalLight() {
  directionalLight.visible = !directionalLight.visible;
  updatedDirectionalLight =  false;
}

function updatePointLight() {
  pointLight.visible = !pointLight.visible;
  updatedPointLight = false;
}

function resetScene() {
  grass.reset();
  golfBall.reset();
  golfFlag.reset();
  updatedReset = false;
}


function render() {
  renderer.render(scene, camera);
  
  if(pause) {
    renderer.autoClear = false;
    renderer.render(pauseScene, pauseCamera);
    renderer.autoClear = true;
  }
}


function animate() {
  let delta = clock.getDelta();

  if (!pause) {
    animateGolfFlag(delta);
    animateGolfBall(delta);
  }

  if(updatedWireframe) updateWireframe();
  if(updatedMaterial) updateMaterial();
  if(updatedReset) resetScene();
  if(updatedDirectionalLight) updateDirectionalLight();
  if(updatedPointLight) updatePointLight();

  render();
  requestAnimationFrame(animate);
}



/*
  INICIALIZACAO
*/
function init() {

  renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  createScene();
  createPause();

  onWindowResize();

  window.addEventListener("keydown", onKeyDown);
  window.addEventListener("resize", onWindowResize);

  render();
}

init();
animate();