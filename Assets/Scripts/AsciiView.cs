// ASCII View Shader: Script del shader d'espai imatge ASCII
// Creat per Aleix Ferr� Juan, Joel P�rez Abad i Eric Joaquin Villena Ninapait�n

using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class AsciiView : MonoBehaviour {
	// VARIABLES PRIVADES
	private Shader shader;

	private Material material; // material amb la textura que tocar� posar en el p�xel

	// Textures dels caracters ASCII disponibles
	private Texture andTextureASCII;
	private Texture asterixTextureASCII;
	private Texture bracketTextureASCII;
	private Texture dollarTextureASCII;
	private Texture dotTextureASCII;
	private Texture minusTextureASCII;
	private Texture pTextureASCII;
	private Texture plusTextureASCII;
	private Texture rTextureASCII;
	private Texture tildeTextureASCII;

	private void Awake() {
		shader = Shader.Find("NPR/AsciiShader");
		if (shader == null) {
			Debug.LogError(@"Ascii shader no encontrado");
			this.enabled = false;
		}
	}

	private void OnEnable() {
		if (shader == null) {
			Debug.LogError(string.Format("'{0}' shader nulo.", this.GetType().ToString()));

			this.enabled = false;
		} else {
			CreateMaterial();

			if (material == null)
				this.enabled = false;
		}
	}

	private void OnDisable() {
		if (material != null)
			DestroyImmediate(material);
	}

	private void CreateMaterial() {
		if (shader != null) {
			if (material != null) {
				if (Application.isEditor == true)
					DestroyImmediate(material);
				else
					Destroy(material);
			}

			material = new Material(shader);
			if (material == null) {
				Debug.LogWarning(string.Format("'{0}' material null.", this.name));
				return;
			}

			// Carreguem les textures
			andTextureASCII = LoadTexture("ascii_and");
			asterixTextureASCII = LoadTexture("ascii_asterix");
			bracketTextureASCII = LoadTexture("ascii_bracket");
			dollarTextureASCII = LoadTexture("ascii_dollar");
			dotTextureASCII = LoadTexture("ascii_dot");
			minusTextureASCII = LoadTexture("ascii_minus");
			pTextureASCII = LoadTexture("ascii_p");
			plusTextureASCII = LoadTexture("ascii_plus");
			rTextureASCII = LoadTexture("ascii_r");
			tildeTextureASCII = LoadTexture("ascii_tilde");
		}
	}

	private Texture LoadTexture(string texturePath) {
		Texture tex = Resources.Load<Texture>("Textures/" + texturePath);
		if (tex == null) {
			Debug.LogError(string.Format("Textura '{0}' no encontrado!", "Textures/" + texturePath));

			return null;
		}

		tex.wrapMode = TextureWrapMode.Repeat;
		tex.filterMode = FilterMode.Point;

		return tex;
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination) {
		if (material != null) {
			material.SetFloat(@"screenWidthMultiplier", (Screen.width / 9.0f));
			material.SetFloat(@"screenHeightMultiplier", (Screen.height / 10.0f));

			material.SetTexture(@"andSampler", andTextureASCII);
			material.SetTexture(@"asterixSampler", asterixTextureASCII);
			material.SetTexture(@"bracketSampler", bracketTextureASCII);
			material.SetTexture(@"dollarSampler", dollarTextureASCII);
			material.SetTexture(@"dotSampler", dotTextureASCII);
			material.SetTexture(@"minusSampler", minusTextureASCII);
			material.SetTexture(@"pSampler", pTextureASCII);
			material.SetTexture(@"plusSampler", plusTextureASCII);
			material.SetTexture(@"rSampler", rTextureASCII);
			material.SetTexture(@"tildeSampler", tildeTextureASCII);

			Graphics.Blit(source, destination, material, 0);
		}
	}
}