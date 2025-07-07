<%@ Page Title="Aircraft Customization" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Customization.aspx.cs" Inherits="AircraftManagement.Customization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.134.0/examples/js/controls/OrbitControls.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.134.0/examples/js/loaders/GLTFLoader.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.134.0/examples/js/objects/Fire.js"></script>

    <div class="customization-wrapper">
        <div class="container-fluid p-0">
            <div class="row g-0">
                <!-- Customization Options Panel (Left Side) -->
                <div class="col-lg-4 customization-panel">
                    <div class="p-4">
                        <h4 class="mb-4 text-white"><i class="fas fa-plane me-2"></i>Customize Your Aircraft</h4>

                        <!-- Aircraft Selection -->
                        <div class="mb-4">
                            <label class="form-label text-white">Select Aircraft</label>
                            <asp:DropDownList ID="ddlAircrafts" runat="server" CssClass="form-select" onchange="loadAircraftModel(this.value)">
                                <asp:ListItem Text="Select an Aircraft" Value=""></asp:ListItem>
                                <asp:ListItem Text="Cessna 172" Value="cessna172"></asp:ListItem>
                                <asp:ListItem Text="Gulfstream G650" Value="gulfstream"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Exterior Customization -->
                        <div class="mb-4">
                            <h5 class="text-white mb-3">Exterior</h5>
                            <!-- Aircraft Size -->
                            <div class="mb-3">
                                <label class="form-label text-white">Aircraft Size</label>
                                <input type="range" class="form-range" id="aircraftSizeSlider" min="1" max="10" value="5" oninput="changeAircraftSize(this.value)">
                            </div>
                            <!-- Body Color -->
                            <div class="mb-3">
                                <label class="form-label text-white">Body Color</label>
                                <div class="color-options d-flex gap-2 flex-wrap">
                                    <button type="button" class="color-swatch" style="background: #ff0000;" onclick="changeBodyColor(0xff0000)" title="Red"></button>
                                    <button type="button" class="color-swatch" style="background: #0000ff;" onclick="changeBodyColor(0x0000ff)" title="Blue"></button>
                                    <button type="button" class="color-swatch" style="background: #ffffff;" onclick="changeBodyColor(0xffffff)" title="White"></button>
                                    <button type="button" class="color-swatch" style="background: #000000;" onclick="changeBodyColor(0x000000)" title="Black"></button>
                                    <button type="button" class="color-swatch" style="background: #c0c0c0;" onclick="changeBodyColor(0xc0c0c0)" title="Silver"></button>
                                    <input type="color" id="customBodyColor" class="color-swatch custom-color-picker" onchange="changeBodyColor(parseInt(this.value.replace('#', '0x')))" title="Custom Color">
                                </div>
                            </div>
                            <!-- Wing Color -->
                            <div class="mb-3">
                                <label class="form-label text-white">Wing Color</label>
                                <div class="color-options d-flex gap-2 flex-wrap">
                                    <button type="button" class="color-swatch" style="background: #ff0000;" onclick="changeWingColor(0xff0000)" title="Red"></button>
                                    <button type="button" class="color-swatch" style="background: #0000ff;" onclick="changeWingColor(0x0000ff)" title="Blue"></button>
                                    <button type="button" class="color-swatch" style="background: #ffffff;" onclick="changeWingColor(0xffffff)" title="White"></button>
                                    <button type="button" class="color-swatch" style="background: #000000;" onclick="changeWingColor(0x000000)" title="Black"></button>
                                    <button type="button" class="color-swatch" style="background: #c0c0c0;" onclick="changeWingColor(0xc0c0c0)" title="Silver"></button>
                                    <input type="color" id="customWingColor" class="color-swatch custom-color-picker" onchange="changeWingColor(parseInt(this.value.replace('#', '0x')))" title="Custom Color">
                                </div>
                            </div>
                            <!-- Decals -->
                            <div class="mb-3">
                                <label class="form-label text-white">Decals</label>
                                <select class="form-select" id="decalSelect" onchange="changeDecal(this.value)">
                                    <option value="none">None</option>
                                    <option value="logo">Company Logo</option>
                                    <option value="stripes">Racing Stripes</option>
                                </select>
                            </div>
                            <!-- Custom Decal Upload -->
                            <div class="mb-3">
                                <label class="form-label text-white">Upload Custom Decal</label>
                                <input type="file" id="decalUpload" accept="image/*" class="form-control" onchange="uploadCustomDecal(this)">
                            </div>
                            <!-- Wing Type -->
                            <div class="mb-3">
                                <label class="form-label text-white">Wing Type</label>
                                <select class="form-select" id="wingTypeSelect" onchange="changeWingType(this.value)">
                                    <option value="straight">Straight Wing</option>
                                    <option value="swept">Swept Wing</option>
                                </select>
                            </div>
                            <!-- Wing Size -->
                            <div class="mb-3">
                                <label class="form-label text-white">Wing Size</label>
                                <input type="range" class="form-range" id="wingSizeSlider" min="0.5" max="2" step="0.1" value="1" oninput="changeWingSize(this.value)">
                            </div>
                            <!-- Tail Style -->
                            <div class="mb-3">
                                <label class="form-label text-white">Tail Style</label>
                                <select class="form-select" id="tailStyleSelect" onchange="changeTailStyle(this.value)">
                                    <option value="conventional">Conventional</option>
                                    <option value="t-tail">T-Tail</option>
                                </select>
                            </div>
                            <!-- Engine Upgrades -->
                            <div class="mb-3">
                                <label class="form-label text-white">Engine Upgrades</label>
                                <select class="form-select" id="engineSelect" onchange="changeEngine(this.value)">
                                    <option value="standard">Standard</option>
                                    <option value="turbo">Turbo</option>
                                    <option value="jet">Jet</option>
                                </select>
                            </div>
                            <!-- Landing Gear -->
                            <div class="mb-3">
                                <label class="form-label text-white">Landing Gear Type</label>
                                <select class="form-select" id="gearTypeSelect" onchange="changeLandingGearType(this.value)">
                                    <option value="fixed">Fixed</option>
                                    <option value="retractable">Retractable</option>
                                </select>
                            </div>
                            <!-- Gear Size -->
                            <div class="mb-3">
                                <label class="form-label text-white">Gear Size</label>
                                <input type="range" class="form-range" id="gearSizeSlider" min="0.5" max="2" step="0.1" value="1" oninput="changeGearSize(this.value)">
                            </div>
                        </div>

                        <!-- Interior Customization -->
                        <div class="mb-4">
                            <h5 class="text-white mb-3">Interior</h5>
                            <!-- Interior Theme -->
                            <div class="mb-3">
                                <label class="form-label text-white">Interior Theme</label>
                                <select class="form-select" id="interiorThemeSelect" onchange="changeInteriorTheme(this.value)">
                                    <option value="luxury">Luxury Leather</option>
                                    <option value="business">Business</option>
                                    <option value="minimalist">Minimalist</option>
                                </select>
                            </div>
                            <!-- Seat Material -->
                            <div class="mb-3">
                                <label class="form-label text-white">Seat Material</label>
                                <select class="form-select" id="seatMaterialSelect" onchange="changeSeatMaterial(this.value)">
                                    <option value="leather">Leather</option>
                                    <option value="fabric">Fabric</option>
                                    <option value="custom">Custom</option>
                                </select>
                            </div>
                            <!-- Seat Color -->
                            <div class="mb-3">
                                <label class="form-label text-white">Seat Color</label>
                                <div class="color-options d-flex gap-2 flex-wrap">
                                    <button type="button" class="color-swatch" style="background: #ffffff;" onclick="changeSeatColor(0xffffff)" title="White"></button>
                                    <button type="button" class="color-swatch" style="background: #000000;" onclick="changeSeatColor(0x000000)" title="Black"></button>
                                    <button type="button" class="color-swatch" style="background: #8b4513;" onclick="changeSeatColor(0x8b4513)" title="Brown"></button>
                                    <input type="color" id="customSeatColor" class="color-swatch custom-color-picker" onchange="changeSeatColor(parseInt(this.value.replace('#', '0x')))" title="Custom Color">
                                </div>
                            </div>
                        </div>

                        <!-- Lighting Effects -->
                        <div class="mb-4">
                            <h5 class="text-white mb-3">Lighting Effects</h5>
                            <div class="mb-3">
                                <label class="form-label text-white">Interior Lighting</label>
                                <select class="form-select" id="interiorLightingSelect" onchange="changeInteriorLighting(this.value)">
                                    <option value="standard">Standard</option>
                                    <option value="ambient">Ambient</option>
                                    <option value="rgb">RGB Customizable</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-white">Exterior Lighting</label>
                                <select class="form-select" id="exteriorLightingSelect" onchange="changeExteriorLighting(this.value)">
                                    <option value="standard">Standard</option>
                                    <option value="led">LED</option>
                                    <option value="custom">Custom</option>
                                </select>
                            </div>
                        </div>

                        <!-- Hidden Fields for Server-Side Saving -->
                        <asp:HiddenField ID="hdnCurrentBodyColor" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentWingColor" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentDecal" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentWingType" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentWingSize" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentTailStyle" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentEngine" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentGearType" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentGearSize" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentAircraftSize" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentInteriorTheme" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentSeatMaterial" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentSeatColor" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentInteriorLighting" runat="server" ClientIDMode="Static" />
                        <asp:HiddenField ID="hdnCurrentExteriorLighting" runat="server" ClientIDMode="Static" />

                        <!-- Actions -->
                        <div class="d-flex justify-content-between">
                            <asp:Button ID="btnSaveCustomization" runat="server" CssClass="btn btn-primary" Text="Save Customization" OnClick="btnSaveCustomization_Click" />
                            <button type="button" class="btn btn-outline-secondary" onclick="resetCustomization()">Reset</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="exportSnapshot()">Export Snapshot</button>
                        </div>

                        <!-- Feedback Message -->
                        <asp:Label ID="lblFeedbackMessage" runat="server" CssClass="alert d-block text-center mt-4" Visible="false"></asp:Label>

                        <!-- Customization Summary -->
                        <div class="mt-4">
                            <h5 class="text-white mb-3">Customization Summary</h5>
                            <ul class="list-unstyled text-white">
                                <li>Aircraft Size: <span id="summaryAircraftSize">5</span></li>
                                <li>Body Color: <span id="summaryBodyColor">White</span></li>
                                <li>Wing Color: <span id="summaryWingColor">White</span></li>
                                <li>Decals: <span id="summaryDecal">None</span></li>
                                <li>Wing Type: <span id="summaryWingType">Straight Wing</span></li>
                                <li>Wing Size: <span id="summaryWingSize">1</span></li>
                                <li>Tail Style: <span id="summaryTailStyle">Conventional</span></li>
                                <li>Engine: <span id="summaryEngine">Standard</span></li>
                                <li>Landing Gear Type: <span id="summaryGearType">Fixed</span></li>
                                <li>Landing Gear Size: <span id="summaryGearSize">1</span></li>
                                <li>Interior Theme: <span id="summaryInteriorTheme">Luxury Leather</span></li>
                                <li>Seat Material: <span id="summarySeatMaterial">Leather</span></li>
                                <li>Seat Color: <span id="summarySeatColor">White</span></li>
                                <li>Interior Lighting: <span id="summaryInteriorLighting">Standard</span></li>
                                <li>Exterior Lighting: <span id="summaryExteriorLighting">Standard</span></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- 3D Viewer (Right Side) -->
                <div class="col-lg-8">
                    <div id="aircraftViewer" class="viewer-container"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Custom Styles -->
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            min-height: 100vh;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .customization-wrapper {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .customization-panel {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-right: 1px solid rgba(255, 255, 255, 0.2);
            height: 100vh;
            overflow-y: auto;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .viewer-container {
            width: 100%;
            height: 100vh;
            background: rgba(0, 0, 0, 0.3);
            position: relative;
            border-radius: 0;
            overflow: hidden;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }

        h4, h5 {
            font-weight: 500;
        }

        h4 {
            font-size: 1.8rem;
        }

        h5 {
            font-size: 1.2rem;
        }

        .form-label {
            font-weight: 500;
            color: #fff;
        }

        .form-select, .form-control, .form-range {
            border-radius: 8px;
            background: #fff;
            color: #333;
            transition: all 0.3s ease;
        }

        .form-select:focus, .form-control:focus, .form-range:focus {
            border-color: #2a5298;
            box-shadow: 0 0 5px rgba(42, 82, 152, 0.3);
        }

        .color-options {
            display: flex;
            gap: 10px;
        }

        .color-swatch {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid #fff;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .color-swatch:hover {
            transform: scale(1.1);
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
        }

        .custom-color-picker {
            width: 40px;
            height: 40px;
            padding: 0;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background: #2a5298;
            border: none;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: #1e3c72;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-outline-secondary {
            border-color: #6c757d;
            color: #fff;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-outline-secondary:hover {
            background: #6c757d;
            color: #fff;
        }

        .alert {
            border-radius: 10px;
            font-weight: 500;
        }

        .list-unstyled li {
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        @media (max-width: 992px) {
            .viewer-container {
                height: 50vh;
            }

            .customization-panel {
                height: auto;
                max-height: 50vh;
            }
        }

        @media (max-width: 768px) {
            .viewer-container {
                height: 40vh;
            }

            .customization-panel {
                padding: 20px;
            }

            h4 {
                font-size: 1.5rem;
            }

            h5 {
                font-size: 1rem;
            }

            .color-swatch {
                width: 30px;
                height: 30px;
            }
        }
    </style>

    <!-- 3D Aircraft Script -->
    <script type="text/javascript">
        let scene, camera, renderer, aircraft, controls, runway, sky, interiorLight, exteriorLight, turboEffect;
        let straightWings, sweptWings, conventionalTail, tTail, fixedGear, retractableGear;
        let currentBodyColor = 0xffffff;
        let currentWingColor = 0xffffff;
        let currentDecal = 'none';
        let currentDecalTexture = null;
        let currentWingType = 'straight';
        let currentWingSize = 1;
        let currentTailStyle = 'conventional';
        let currentEngine = 'standard';
        let currentGearType = 'fixed';
        let currentGearSize = 1;
        let currentAircraftSize = 5;
        let currentInteriorTheme = 'luxury';
        let currentSeatMaterial = 'leather';
        let currentSeatColor = 0xffffff;
        let currentInteriorLighting = 'standard';
        let currentExteriorLighting = 'standard';

        function init() {
            // Scene
            scene = new THREE.Scene();

            // Camera
            camera = new THREE.PerspectiveCamera(75, document.getElementById('aircraftViewer').clientWidth / document.getElementById('aircraftViewer').clientHeight, 0.1, 1000);
            camera.position.set(0, 10, 30);

            // Renderer
            renderer = new THREE.WebGLRenderer({ antialias: true });
            renderer.setSize(document.getElementById('aircraftViewer').clientWidth, document.getElementById('aircraftViewer').clientHeight);
            document.getElementById('aircraftViewer').appendChild(renderer.domElement);

            // Controls
            controls = new THREE.OrbitControls(camera, renderer.domElement);
            controls.enableDamping = true;
            controls.dampingFactor = 0.05;
            controls.screenSpacePanning = false;
            controls.minDistance = 10;
            controls.maxDistance = 50;
            controls.maxPolarAngle = Math.PI / 2;

            // Lighting
            const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
            scene.add(ambientLight);

            const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
            directionalLight.position.set(5, 10, 5);
            scene.add(directionalLight);

            // Interior and Exterior Lights
            interiorLight = new THREE.PointLight(0xffffff, 0, 10);
            interiorLight.position.set(0, 2, 0);
            scene.add(interiorLight);

            exteriorLight = new THREE.SpotLight(0xffffff, 0, 20);
            exteriorLight.position.set(0, 5, 10);
            exteriorLight.angle = Math.PI / 4;
            scene.add(exteriorLight);

            // Background - Runway and Sky
            const runwayGeometry = new THREE.PlaneGeometry(200, 200);
            const runwayTexture = new THREE.TextureLoader().load('https://images.unsplash.com/photo-1596436889106-be35e843f974?ixlib=rb-4.0.3&auto=format&fit=crop&w=1950&q=80');
            const runwayMaterial = new THREE.MeshBasicMaterial({ map: runwayTexture });
            runway = new THREE.Mesh(runwayGeometry, runwayMaterial);
            runway.rotation.x = -Math.PI / 2;
            runway.position.y = -2;
            scene.add(runway);

            const skyGeometry = new THREE.SphereGeometry(500, 32, 32);
            const skyMaterial = new THREE.MeshBasicMaterial({ color: 0x87ceeb, side: THREE.BackSide });
            sky = new THREE.Mesh(skyGeometry, skyMaterial);
            scene.add(sky);

            // Load Aircraft Model and Parts
            loadAircraftModel('cessna172');
            loadAircraftParts();

            // Resize Handler
            window.addEventListener('resize', onWindowResize, false);

            animate();
        }

        function onWindowResize() {
            camera.aspect = document.getElementById('aircraftViewer').clientWidth / document.getElementById('aircraftViewer').clientHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(document.getElementById('aircraftViewer').clientWidth, document.getElementById('aircraftViewer').clientHeight);
        }

        function animate() {
            requestAnimationFrame(animate);
            controls.update();
            if (turboEffect) {
                turboEffect.update();
            }
            renderer.render(scene, camera);
        }

        function loadAircraftModel(modelType) {
            if (aircraft) {
                scene.remove(aircraft);
            }

            const loader = new THREE.GLTFLoader();
            let modelUrl;
            switch (modelType) {
                case 'cessna172':
                    modelUrl = '/models/cessna172.glb';
                    break;
                case 'gulfstream':
                    modelUrl = '/models/gulfstream.glb';
                    break;
                default:
                    return;
            }

            loader.load(
                modelUrl,
                (gltf) => {
                    aircraft = gltf.scene;
                    aircraft.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
                    aircraft.position.set(0, -1, 0);
                    aircraft.rotation.y = Math.PI / 2;
                    scene.add(aircraft);
                    applyCustomization();
                },
                (xhr) => {
                    console.log((xhr.loaded / xhr.total * 100) + '% loaded');
                },
                (error) => {
                    console.error('Error loading model:', error);
                    alert('Failed to load aircraft model. Please ensure the model file is correctly placed and accessible.');
                }
            );
        }

        function loadAircraftParts() {
            const loader = new THREE.GLTFLoader();

            // Load Straight Wings
            loader.load(
                '/models/straight_wings.glb',
                (gltf) => {
                    straightWings = gltf.scene;
                    straightWings.visible = false;
                    straightWings.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
                    straightWings.position.set(0, -1, 0);
                    straightWings.rotation.y = Math.PI / 2;
                    scene.add(straightWings);
                    applyCustomization();
                },
                undefined,
                (error) => {
                    console.error('Error loading straight wings:', error);
                }
            );

            // Load Swept Wings
            loader.load(
                '/models/swept_wings.glb',
                (gltf) => {
                    sweptWings = gltf.scene;
                    sweptWings.visible = false;
                    sweptWings.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
                    sweptWings.position.set(0, -1, 0);
                    sweptWings.rotation.y = Math.PI / 2;
                    scene.add(sweptWings);
                    applyCustomization();
                },
                undefined,
                (error) => {
                    console.error('Error loading swept wings:', error);
                }
            );

            // Load Conventional Tail
            loader.load(
                '/models/conventional_tail.glb',
                (gltf) => {
                    conventionalTail = gltf.scene;
                    conventionalTail.visible = false;
                    conventionalTail.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
                    conventionalTail.position.set(0, -1, 0);
                    conventionalTail.rotation.y = Math.PI / 2;
                    scene.add(conventionalTail);
                    applyCustomization();
                },
                undefined,
                (error) => {
                    console.error('Error loading conventional tail:', error);
                }
            );

            // Load T-Tail
            loader.load(
                '/models/t_tail.glb',
                (gltf) => {
                    tTail = gltf.scene;
                    tTail.visible = false;
                    tTail.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
                    tTail.position.set(0, -1, 0);
                    tTail.rotation.y = Math.PI / 2;
                    scene.add(tTail);
                    applyCustomization();
                },
                undefined,
                (error) => {
                    console.error('Error loading T-tail:', error);
                }
            );

            // Load Fixed Gear
            loader.load(
                '/models/fixed_gear.glb',
                (gltf) => {
                    fixedGear = gltf.scene;
                    fixedGear.visible = false;
                    fixedGear.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
                    fixedGear.position.set(0, -1, 0);
                    fixedGear.rotation.y = Math.PI / 2;
                    scene.add(fixedGear);
                    applyCustomization();
                },
                undefined,
                (error) => {
                    console.error('Error loading fixed gear:', error);
                }
            );

            // Load Retractable Gear
            loader.load(
                '/models/retractable_gear.glb',
                (gltf) => {
                    retractableGear = gltf.scene;
                    retractableGear.visible = false;
                    retractableGear.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
                    retractableGear.position.set(0, -1, 0);
                    retractableGear.rotation.y = Math.PI / 2;
                    scene.add(retractableGear);
                    applyCustomization();
                },
                undefined,
                (error) => {
                    console.error('Error loading retractable gear:', error);
                }
            );
        }

        function applyCustomization() {
            if (!aircraft) return;

            // Apply Aircraft Size
            aircraft.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
            if (straightWings) straightWings.scale.set(currentAircraftSize * currentWingSize, currentAircraftSize, currentAircraftSize);
            if (sweptWings) sweptWings.scale.set(currentAircraftSize * currentWingSize, currentAircraftSize, currentAircraftSize);
            if (conventionalTail) conventionalTail.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
            if (tTail) tTail.scale.set(currentAircraftSize, currentAircraftSize, currentAircraftSize);
            if (fixedGear) fixedGear.scale.set(currentAircraftSize * currentGearSize, currentAircraftSize * currentGearSize, currentAircraftSize * currentGearSize);
            if (retractableGear) retractableGear.scale.set(currentAircraftSize * currentGearSize, currentAircraftSize * currentGearSize, currentAircraftSize * currentGearSize);

            // Apply Body Color
            aircraft.traverse((child) => {
                if (child.isMesh && (child.name.includes('fuselage') || child.name.includes('body'))) {
                    child.material.color.setHex(currentBodyColor);
                }
            });

            // Apply Wing Color and Size
            [straightWings, sweptWings].forEach((wing) => {
                if (wing) {
                    wing.traverse((child) => {
                        if (child.isMesh) {
                            child.material.color.setHex(currentWingColor);
                        }
                    });
                }
            });

            // Apply Decal
            aircraft.traverse((child) => {
                if (child.isMesh && (child.name.includes('fuselage') || child.name.includes('tail'))) {
                    child.material.map = currentDecalTexture;
                    child.material.needsUpdate = true;
                }
            });

            // Apply Wing Type
            if (straightWings) straightWings.visible = currentWingType === 'straight';
            if (sweptWings) sweptWings.visible = currentWingType === 'swept';

            // Apply Tail Style
            if (conventionalTail) conventionalTail.visible = currentTailStyle === 'conventional';
            if (tTail) tTail.visible = currentTailStyle === 't-tail';

            // Apply Engine Upgrades
            if (currentEngine === 'turbo' || currentEngine === 'jet') {
                if (!turboEffect) {
                    aircraft.traverse((child) => {
                        if (child.isMesh && child.name.includes('engine')) {
                            const fireGeometry = new THREE.PlaneGeometry(1, 1);
                            const fireMaterial = new THREE.ShaderMaterial(THREE.FireShader);
                            turboEffect = new THREE.Fire(fireGeometry, fireMaterial);
                            turboEffect.position.copy(child.position);
                            turboEffect.position.z -= 2; // Position behind engine
                            turboEffect.scale.set(2, 2, 2);
                            scene.add(turboEffect);
                        }
                    });
                }
            } else {
                if (turboEffect) {
                    scene.remove(turboEffect);
                    turboEffect = null;
                }
            }

            // Apply Landing Gear Type and Size
            if (fixedGear) fixedGear.visible = currentGearType === 'fixed';
            if (retractableGear) retractableGear.visible = currentGearType === 'retractable';

            // Apply Seat Color
            aircraft.traverse((child) => {
                if (child.isMesh && child.name.includes('seats')) {
                    child.material.color.setHex(currentSeatColor);
                }
            });

            // Apply Interior Lighting
            if (currentInteriorLighting === 'ambient') {
                interiorLight.intensity = 1;
                interiorLight.color.setHex(0xffff00);
            } else if (currentInteriorLighting === 'rgb') {
                interiorLight.intensity = 1;
                interiorLight.color.setHex(Math.random() * 0xffffff);
            } else {
                interiorLight.intensity = 0;
            }

            // Apply Exterior Lighting
            if (currentExteriorLighting === 'led') {
                exteriorLight.intensity = 1;
                exteriorLight.color.setHex(0x00ff00);
            } else if (currentExteriorLighting === 'custom') {
                exteriorLight.intensity = 1;
                exteriorLight.color.setHex(Math.random() * 0xffffff);
            } else {
                exteriorLight.intensity = 0;
            }

            // Format hex colors for database
            const formattedBodyColor = '#' + currentBodyColor.toString(16).padStart(6, '0');
            const formattedWingColor = '#' + currentWingColor.toString(16).padStart(6, '0');
            const formattedSeatColor = '#' + currentSeatColor.toString(16).padStart(6, '0');

            // Update Hidden Fields for Server-Side Saving
            document.getElementById('hdnCurrentBodyColor').value = formattedBodyColor;
            document.getElementById('hdnCurrentWingColor').value = formattedWingColor;
            document.getElementById('hdnCurrentDecal').value = currentDecal;
            document.getElementById('hdnCurrentWingType').value = currentWingType;
            document.getElementById('hdnCurrentWingSize').value = currentWingSize;
            document.getElementById('hdnCurrentTailStyle').value = currentTailStyle;
            document.getElementById('hdnCurrentEngine').value = currentEngine;
            document.getElementById('hdnCurrentGearType').value = currentGearType;
            document.getElementById('hdnCurrentGearSize').value = currentGearSize;
            document.getElementById('hdnCurrentAircraftSize').value = currentAircraftSize;
            document.getElementById('hdnCurrentInteriorTheme').value = currentInteriorTheme;
            document.getElementById('hdnCurrentSeatMaterial').value = currentSeatMaterial;
            document.getElementById('hdnCurrentSeatColor').value = formattedSeatColor;
            document.getElementById('hdnCurrentInteriorLighting').value = currentInteriorLighting;
            document.getElementById('hdnCurrentExteriorLighting').value = currentExteriorLighting;

            // Update Summary
            document.getElementById('summaryAircraftSize').textContent = currentAircraftSize;
            document.getElementById('summaryBodyColor').textContent = getColorName(currentBodyColor);
            document.getElementById('summaryWingColor').textContent = getColorName(currentWingColor);
            document.getElementById('summaryDecal').textContent = currentDecal.charAt(0).toUpperCase() + currentDecal.slice(1);
            document.getElementById('summaryWingType').textContent = currentWingType === 'straight' ? 'Straight Wing' : 'Swept Wing';
            document.getElementById('summaryWingSize').textContent = currentWingSize;
            document.getElementById('summaryTailStyle').textContent = currentTailStyle === 'conventional' ? 'Conventional' : 'T-Tail';
            document.getElementById('summaryEngine').textContent = currentEngine.charAt(0).toUpperCase() + currentEngine.slice(1);
            document.getElementById('summaryGearType').textContent = currentGearType.charAt(0).toUpperCase() + currentGearType.slice(1);
            document.getElementById('summaryGearSize').textContent = currentGearSize;
            document.getElementById('summaryInteriorTheme').textContent = currentInteriorTheme.charAt(0).toUpperCase() + currentInteriorTheme.slice(1);
            document.getElementById('summarySeatMaterial').textContent = currentSeatMaterial.charAt(0).toUpperCase() + currentSeatMaterial.slice(1);
            document.getElementById('summarySeatColor').textContent = getColorName(currentSeatColor);
            document.getElementById('summaryInteriorLighting').textContent = currentInteriorLighting.charAt(0).toUpperCase() + currentInteriorLighting.slice(1);
            document.getElementById('summaryExteriorLighting').textContent = currentExteriorLighting.charAt(0).toUpperCase() + currentExteriorLighting.slice(1);
        }

        function getColorName(hex) {
            switch (hex) {
                case 0xff0000: return 'Red';
                case 0x0000ff: return 'Blue';
                case 0xffffff: return 'White';
                case 0x000000: return 'Black';
                case 0xc0c0c0: return 'Silver';
                case 0x8b4513: return 'Brown';
                default: return '#' + hex.toString(16).padStart(6, '0');
            }
        }

        function changeAircraftSize(size) {
            currentAircraftSize = parseFloat(size);
            applyCustomization();
        }

        function changeBodyColor(color) {
            currentBodyColor = color;
            applyCustomization();
        }

        function changeWingColor(color) {
            currentWingColor = color;
            applyCustomization();
        }

        function changeDecal(decal) {
            currentDecal = decal;
            const textureLoader = new THREE.TextureLoader();
            if (decal === 'logo') {
                currentDecalTexture = textureLoader.load('/textures/logo.png');
            } else if (decal === 'stripes') {
                currentDecalTexture = textureLoader.load('/textures/stripes.png');
            } else {
                currentDecalTexture = null;
            }
            applyCustomization();
        }

        function uploadCustomDecal(input) {
            const file = input.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const textureLoader = new THREE.TextureLoader();
                    currentDecalTexture = textureLoader.load(e.target.result);
                    currentDecal = 'custom';
                    applyCustomization();
                };
                reader.readAsDataURL(file);
            }
        }

        function changeWingType(wingType) {
            currentWingType = wingType;
            applyCustomization();
        }

        function changeWingSize(size) {
            currentWingSize = parseFloat(size);
            applyCustomization();
        }

        function changeTailStyle(tailStyle) {
            currentTailStyle = tailStyle;
            applyCustomization();
        }

        function changeEngine(engine) {
            currentEngine = engine;
            applyCustomization();
        }

        function changeLandingGearType(gearType) {
            currentGearType = gearType;
            applyCustomization();
        }

        function changeGearSize(size) {
            currentGearSize = parseFloat(size);
            applyCustomization();
        }

        function changeInteriorTheme(theme) {
            currentInteriorTheme = theme;
            applyCustomization();
        }

        function changeSeatMaterial(material) {
            currentSeatMaterial = material;
            applyCustomization();
        }

        function changeSeatColor(color) {
            currentSeatColor = color;
            applyCustomization();
        }

        function changeInteriorLighting(lighting) {
            currentInteriorLighting = lighting;
            applyCustomization();
        }

        function changeExteriorLighting(lighting) {
            currentExteriorLighting = lighting;
            applyCustomization();
        }

        function resetCustomization() {
            currentBodyColor = 0xffffff;
            currentWingColor = 0xffffff;
            currentDecal = 'none';
            currentDecalTexture = null;
            currentWingType = 'straight';
            currentWingSize = 1;
            currentTailStyle = 'conventional';
            currentEngine = 'standard';
            currentGearType = 'fixed';
            currentGearSize = 1;
            currentAircraftSize = 5;
            currentInteriorTheme = 'luxury';
            currentSeatMaterial = 'leather';
            currentSeatColor = 0xffffff;
            currentInteriorLighting = 'standard';
            currentExteriorLighting = 'standard';
            document.getElementById('aircraftSizeSlider').value = 5;
            document.getElementById('decalSelect').value = 'none';
            document.getElementById('wingTypeSelect').value = 'straight';
            document.getElementById('wingSizeSlider').value = 1;
            document.getElementById('tailStyleSelect').value = 'conventional';
            document.getElementById('engineSelect').value = 'standard';
            document.getElementById('gearTypeSelect').value = 'fixed';
            document.getElementById('gearSizeSlider').value = 1;
            document.getElementById('interiorThemeSelect').value = 'luxury';
            document.getElementById('seatMaterialSelect').value = 'leather';
            document.getElementById('interiorLightingSelect').value = 'standard';
            document.getElementById('exteriorLightingSelect').value = 'standard';
            applyCustomization();
        }

        function exportSnapshot() {
            renderer.render(scene, camera);
            const link = document.createElement('a');
            link.download = 'custom-aircraft.png';
            link.href = renderer.domElement.toDataURL('image/png');
            link.click();
        }

        document.addEventListener('DOMContentLoaded', init);
    </script>
</asp:Content>